//
//  ClaudeService.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import Foundation

class ClaudeService {
    private static let apiKey = "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"
    private static let apiURL = "https://api.anthropic.com/v1/messages"
    
    // Configure URLSession with proper settings
    private static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 120.0
        configuration.httpAdditionalHeaders = [
            "User-Agent": "GymFit-iOS/1.0"
        ]
        return URLSession(configuration: configuration)
    }()
    
    func generateWorkout(equipment: [String], bodyParts: [String], timeMinutes: Int) async throws -> Workout {
        // Build the prompt
        let equipmentList = equipment.joined(separator: ", ")
        let bodyPartsList = bodyParts.joined(separator: ", ")
        
        let prompt = """
        You are a personal trainer. Generate a workout plan with the following:
        Equipment: \(equipmentList)
        Target: \(bodyPartsList)
        Duration: \(timeMinutes) minutes.
        Respond in JSON format with:
        - warmup: array of exercises
        - main_workout: array of exercises
        - cooldown: array of exercises
        Each exercise should have: name (string), sets (integer), reps (integer), rest_seconds (integer), and instructions (string describing how to perform the exercise).
        """
        
        // Create the request body
        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 4096,
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]
        
        // 1. Verify and create URL
        let apiURLString = "https://api.anthropic.com/v1/messages"
        guard let url = URL(string: apiURLString) else {
            throw ClaudeServiceError.invalidURL
        }
        
        // 2. Convert request body to JSON
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            throw ClaudeServiceError.invalidRequestBody
        }
        
        // 3. Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        // 4. Set all required headers
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(ClaudeService.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        // Debug: Print complete request details
        #if DEBUG
        print("=== Claude API Request ===")
        print("URL: \(url.absoluteString)")
        print("Method: POST")
        print("Headers:")
        print("  content-type: application/json")
        print("  x-api-key: \(ClaudeService.apiKey)")
        print("  anthropic-version: 2023-06-01")
        print("Body Size: \(jsonData.count) bytes")
        if let bodyString = String(data: jsonData, encoding: .utf8) {
            print("Body Preview: \(String(bodyString.prefix(200)))...")
        }
        print("========================")
        #endif
        
        // 5. Make the API call using configured URLSession
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await ClaudeService.urlSession.data(for: request)
        } catch let error as NSError {
            #if DEBUG
            print("Network Error Details:")
            print("  Domain: \(error.domain)")
            print("  Code: \(error.code)")
            print("  Description: \(error.localizedDescription)")
            if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                print("  Underlying Error: \(underlyingError.localizedDescription)")
            }
            #endif
            throw ClaudeServiceError.networkError(error)
        }
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ClaudeServiceError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        
        // Parse the response
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        // Extract content from Claude's response format
        guard let content = responseJSON?["content"] as? [[String: Any]],
              let firstContent = content.first,
              let rawText = firstContent["text"] as? String else {
            throw ClaudeServiceError.invalidResponseFormat
        }
        
        // 1. Print the raw response text for debugging
        #if DEBUG
        print("=== Raw Claude Response ===")
        print(rawText)
        print("===========================")
        #endif
        
        // 2. Clean the text: strip markdown code blocks and extract JSON
        var cleanedText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove markdown code blocks (```json ... ``` or ``` ... ```)
        if cleanedText.hasPrefix("```") {
            // Find the first newline after ```
            if let firstNewline = cleanedText.firstIndex(of: "\n") {
                let afterPrefix = cleanedText.index(after: firstNewline)
                cleanedText = String(cleanedText[afterPrefix...])
            } else {
                // No newline, just remove ```
                cleanedText = cleanedText.replacingOccurrences(of: "```", with: "")
            }
            
            // Remove trailing ```
            if cleanedText.hasSuffix("```") {
                let endIndex = cleanedText.index(cleanedText.endIndex, offsetBy: -3)
                cleanedText = String(cleanedText[..<endIndex])
            }
        }
        
        // Remove "json" prefix if present
        cleanedText = cleanedText.replacingOccurrences(of: "^json\\s*", with: "", options: .regularExpression)
        
        // 3. Extract JSON from mixed text (find the first { and last })
        if let firstBrace = cleanedText.firstIndex(of: "{"),
           let lastBrace = cleanedText.lastIndex(of: "}"),
           firstBrace < lastBrace {
            let jsonEnd = cleanedText.index(after: lastBrace)
            cleanedText = String(cleanedText[firstBrace..<jsonEnd])
        }
        
        // Clean up whitespace
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        #if DEBUG
        print("=== Cleaned JSON Text ===")
        print(cleanedText)
        print("========================")
        #endif
        
        // 4. Parse the cleaned JSON
        guard let jsonData = cleanedText.data(using: .utf8) else {
            throw ClaudeServiceError.invalidJSON
        }
        
        // 5. Decode the Workout
        let decoder = JSONDecoder()
        let workout: Workout
        do {
            workout = try decoder.decode(Workout.self, from: jsonData)
        } catch {
            #if DEBUG
            print("=== JSON Decode Error ===")
            print("Error: \(error)")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Attempted to parse: \(jsonString)")
            }
            print("========================")
            #endif
            throw ClaudeServiceError.invalidJSON
        }
        
        return workout
    }
    
    func sendChatMessage(
        message: String,
        workout: Workout,
        conversationHistory: [ChatMessage] = []
    ) async throws -> String {
        // Build workout context
        let workoutContext = buildWorkoutContext(workout: workout)
        
        // Build messages array with workout context and conversation history
        var messages: [[String: Any]] = []
        
        // Add system message with workout context
        messages.append([
            "role": "user",
            "content": workoutContext
        ])
        
        // Add conversation history (excluding the last user message which we're about to add)
        for chatMessage in conversationHistory {
            messages.append([
                "role": chatMessage.role.rawValue,
                "content": chatMessage.content
            ])
        }
        
        // Add current user message
        messages.append([
            "role": "user",
            "content": message
        ])
        
        // Create the request body
        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 4096,
            "messages": messages
        ]
        
        // Create and configure the request
        guard let url = URL(string: ClaudeService.apiURL) else {
            throw ClaudeServiceError.invalidURL
        }
        
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            throw ClaudeServiceError.invalidRequestBody
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(ClaudeService.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        // Make the API call
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await ClaudeService.urlSession.data(for: request)
        } catch {
            throw ClaudeServiceError.networkError(error)
        }
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ClaudeServiceError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        
        // Parse the response
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let content = responseJSON?["content"] as? [[String: Any]],
              let firstContent = content.first,
              let text = firstContent["text"] as? String else {
            throw ClaudeServiceError.invalidResponseFormat
        }
        
        return text
    }
    
    // Generic AI Coach chat (no workout context)
    func chatWithCoach(message: String, history: [ChatMessage] = []) async throws -> String {
        var messages: [[String: Any]] = []
        
        // System-style priming message with fitness-focused prompt
        messages.append([
            "role": "user",
            "content": """
            You are an AI Fitness Coach. 
            Be direct, simple, motivational, and focus only on:
            - workouts
            - exercises
            - form cues
            - training plans
            - fat loss & muscle gain
            - recovery
            Avoid giving general life advice for now.
            """
        ])
        
        // Conversation history
        for msg in history {
            messages.append([
                "role": msg.role.rawValue,
                "content": msg.content
            ])
        }
        
        // Current user message
        messages.append([
            "role": "user",
            "content": message
        ])
        
        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 1024,
            "messages": messages
        ]
        
        guard let url = URL(string: ClaudeService.apiURL) else {
            throw ClaudeServiceError.invalidURL
        }
        
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            throw ClaudeServiceError.invalidRequestBody
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(ClaudeService.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await ClaudeService.urlSession.data(for: request)
        } catch {
            throw ClaudeServiceError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ClaudeServiceError.apiError(statusCode: httpResponse.statusCode, data: data)
        }
        
        let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let content = responseJSON?["content"] as? [[String: Any]],
              let firstContent = content.first,
              let text = firstContent["text"] as? String else {
            throw ClaudeServiceError.invalidResponseFormat
        }
        
        return text
    }
    
    private func buildWorkoutContext(workout: Workout) -> String {
        var context = "You are a personal trainer assistant. The user is currently following this workout plan:\n\n"
        
        if !workout.warmup.isEmpty {
            context += "WARMUP:\n"
            for (index, exercise) in workout.warmup.enumerated() {
                context += "\(index + 1). \(exercise.name) - \(exercise.sets) sets x \(exercise.reps) reps, \(exercise.restSeconds)s rest\n"
                if !exercise.instructions.isEmpty {
                    context += "   Instructions: \(exercise.instructions)\n"
                }
            }
            context += "\n"
        }
        
        if !workout.mainWorkout.isEmpty {
            context += "MAIN WORKOUT:\n"
            for (index, exercise) in workout.mainWorkout.enumerated() {
                context += "\(index + 1). \(exercise.name) - \(exercise.sets) sets x \(exercise.reps) reps, \(exercise.restSeconds)s rest\n"
                if !exercise.instructions.isEmpty {
                    context += "   Instructions: \(exercise.instructions)\n"
                }
            }
            context += "\n"
        }
        
        if !workout.cooldown.isEmpty {
            context += "COOLDOWN:\n"
            for (index, exercise) in workout.cooldown.enumerated() {
                context += "\(index + 1). \(exercise.name) - \(exercise.sets) sets x \(exercise.reps) reps, \(exercise.restSeconds)s rest\n"
                if !exercise.instructions.isEmpty {
                    context += "   Instructions: \(exercise.instructions)\n"
                }
            }
            context += "\n"
        }
        
        context += "Please help the user with questions about this workout, provide tips, modifications, or answer any fitness-related questions. Be concise and helpful."
        
        return context
    }
}

enum ClaudeServiceError: LocalizedError {
    case invalidURL
    case invalidRequestBody
    case invalidResponse
    case invalidResponseFormat
    case invalidJSON
    case apiError(statusCode: Int, data: Data)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL. Please check the endpoint configuration."
        case .invalidRequestBody:
            return "Failed to create request body"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidResponseFormat:
            return "Response format is not as expected"
        case .invalidJSON:
            return "Failed to parse JSON response"
        case .apiError(let statusCode, let data):
            if let errorMessage = String(data: data, encoding: .utf8) {
                return "API Error (\(statusCode)): \(errorMessage)"
            }
            return "API Error with status code: \(statusCode)"
        case .networkError(let error):
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain {
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    return "No internet connection. Please check your network settings."
                case NSURLErrorCannotFindHost:
                    return "Server hostname not found. Please check your internet connection and DNS settings."
                case NSURLErrorTimedOut:
                    return "Request timed out. Please try again."
                default:
                    return "Network error: \(error.localizedDescription)"
                }
            }
            return "Network error: \(error.localizedDescription)"
        }
    }
}

