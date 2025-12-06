//
//  AICoachView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

struct AICoachView: View {
    @State private var chatMessages: [ChatMessage] = [
        ChatMessage(role: .assistant, content: "Hi! I'm your AI fitness coach. How can I help you today?")
    ]
    @State private var inputMessage = ""
    @State private var isLoading = false
    @FocusState private var isInputFocused: Bool
    
    private let claudeService = ClaudeService()
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. HEADER
            HStack {
                Text("AI Coach")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            // 2. CHAT MESSAGES AREA
            ScrollViewReader { proxy in
                ScrollView {
                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 12) {
                            // Welcome section (only show when no user messages)
                            if chatMessages.filter({ $0.role == .user }).isEmpty {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: "FFEBE9"))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 36))
                                            .foregroundColor(Color(hex: "FF3B30"))
                                    }
                                    
                                    Text("Welcome back! Start a new workout or\nchat with your AI Coach.")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(hex: "8E8E93"))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                        .padding(.horizontal, 48)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 60)
                            } else {
                                // Chat messages (skip first AI welcome message)
                                ForEach(chatMessages.indices, id: \.self) { index in
                                    let msg = chatMessages[index]
                                    if index > 0 || msg.role == .user {
                                        HStack {
                                            if msg.role == .user { Spacer() }
                                            
                                            Text(msg.content)
                                                .font(.system(size: 15))
                                                .foregroundColor(msg.role == .user ? .white : Color(hex: "1C1C1E"))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(msg.role == .user ? Color(hex: "FF3B30") : Color(hex: "F2F2F7"))
                                                .cornerRadius(20)
                                                .frame(maxWidth: geometry.size.width * 0.75, alignment: msg.role == .user ? .trailing : .leading)
                                            
                                            if msg.role == .assistant { Spacer() }
                                        }
                                        .id(index)
                                    }
                                }
                                
                                // Typing indicator
                                if isLoading {
                                    HStack {
                                        TypingIndicatorView()
                                        Spacer()
                                    }
                                    .id("typing")
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(width: geometry.size.width)
                    }
                }
                .onChange(of: chatMessages.count) {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: isLoading) {
                    scrollToBottom(proxy: proxy)
                }
            }
            
            Spacer()
            
            // 3. CHAT INPUT (FIXED AT BOTTOM)
            HStack(spacing: 12) {
                TextField("Ask your AI coach...", text: $inputMessage, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 15))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(hex: "F2F2F7"))
                    .cornerRadius(25)
                    .focused($isInputFocused)
                    .disabled(isLoading)
                    .onSubmit {
                        if !inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            handleSendMessage()
                        }
                    }
                
                Button(action: handleSendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "FF3B30"))
                        .clipShape(Circle())
                }
                .disabled(inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .padding(.top, 12)
        }
        .background(Color.white)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if isLoading {
            withAnimation {
                proxy.scrollTo("typing", anchor: .bottom)
            }
        } else if let lastIndex = chatMessages.indices.last {
            withAnimation {
                proxy.scrollTo(lastIndex, anchor: .bottom)
            }
        }
    }
    
    func handleSendMessage() {
        let trimmedMessage = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty, !isLoading else { return }
        
        // Add user message
        let userMessage = ChatMessage(role: .user, content: trimmedMessage)
        chatMessages.append(userMessage)
        inputMessage = ""
        isInputFocused = false
        isLoading = true
        
        // Get conversation history (excluding the system message)
        let history = Array(chatMessages.dropFirst())
        
        // Call Claude API
        Task {
            do {
                let reply = try await claudeService.chatWithCoach(message: trimmedMessage, history: history)
                await MainActor.run {
                    let aiMessage = ChatMessage(role: .assistant, content: reply)
                    chatMessages.append(aiMessage)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    let errorMessage = (error as? ClaudeServiceError)?.errorDescription ?? error.localizedDescription
                    let aiMessage = ChatMessage(role: .assistant, content: "Sorry, I encountered an error: \(errorMessage). Please try again.")
                    chatMessages.append(aiMessage)
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Typing Indicator

struct TypingIndicatorView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color(hex: "8E8E93"))
                    .frame(width: 8, height: 8)
                    .opacity(Double((Int(phase) + index) % 3 == 0 ? 1 : 0.3))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "F2F2F7"))
        .cornerRadius(20)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: false)) {
                phase = 3
            }
        }
    }
}

// MARK: - Color hex helper

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    AICoachView()
}
