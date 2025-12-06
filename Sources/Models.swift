//
//  Models.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: UUID
    let name: String
    let sets: Int
    let reps: Int
    let restSeconds: Int
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sets
        case reps
        case restSeconds = "rest_seconds"
        case instructions
    }
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: Int, restSeconds: Int, instructions: String) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.restSeconds = restSeconds
        self.instructions = instructions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        sets = try container.decode(Int.self, forKey: .sets)
        reps = try container.decode(Int.self, forKey: .reps)
        restSeconds = try container.decode(Int.self, forKey: .restSeconds)
        instructions = try container.decode(String.self, forKey: .instructions)
    }
}

struct Workout: Codable {
    let warmup: [Exercise]
    let mainWorkout: [Exercise]
    let cooldown: [Exercise]
    
    enum CodingKeys: String, CodingKey {
        case warmup
        case mainWorkout = "main_workout"
        case cooldown
    }
}

struct SavedWorkout: Codable, Identifiable {
    let id: UUID
    let workout: Workout
    let date: Date
    
    init(id: UUID = UUID(), workout: Workout, date: Date = Date()) {
        self.id = id
        self.workout = workout
        self.date = date
    }
}

struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    enum MessageRole: String, Codable {
        case user
        case assistant
    }
    
    init(id: UUID = UUID(), role: MessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
