//
//  SettingsView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var workoutReminders = true
    @State private var achievementAlerts = true
    @State private var weeklySummary = false
    @State private var darkMode = false
    
    var body: some View {
        VStack(spacing: 0) {
            // HEADER
            HStack {
                Text("Settings")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            // SCROLLABLE CONTENT
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // PROFILE CARD (no section header)
                    SettingsCard {
                        HStack(spacing: 16) {
                            // Profile Image
                            Circle()
                                .fill(Color(hex: "E5E5EA"))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color(hex: "8E8E93"))
                                )
                            
                            // Name and Email
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Alex Thompson")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(hex: "1C1C1E"))
                                
                                Text("alex.thompson@email.com")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color(hex: "6E6E73"))
                            }
                            
                            Spacer()
                        }
                        .padding(14)
                    }
                    
                    // PROFILE DETAILS CARD
                    SettingsCard {
                        VStack(spacing: 0) {
                            SettingsRow(title: "Gender", value: "Female", hasArrow: true)
                            SettingsRow(title: "Age", value: "28", hasArrow: true)
                            SettingsRow(title: "Height", value: "5'10\"", hasArrow: true)
                            SettingsRow(title: "Weight", value: "165 lbs", hasArrow: true)
                        }
                    }
                    
                    // SUBSCRIPTION SECTION
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Subscription")
                            .font(.system(size: 17.5, weight: .regular))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        SettingsCard {
                            SettingsTitleSubtitleRow(
                                title: "Manage Subscription",
                                subtitle: "Premium • Renews Dec 15, 2025",
                                hasArrow: true
                            )
                        }
                    }
                    
                    // MY GYM EQUIPMENT SECTION
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My Gym Equipment")
                            .font(.system(size: 17.5, weight: .regular))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        SettingsCard {
                            SettingsTitleSubtitleRow(
                                title: "Your Gym Setup",
                                subtitle: "Manage your gym equipment",
                                hasArrow: true
                            )
                        }
                    }
                    
                    // APP SETTINGS SECTION
                    VStack(alignment: .leading, spacing: 6) {
                        Text("App Settings")
                            .font(.system(size: 17.5, weight: .regular))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        SettingsCard {
                            VStack(spacing: 0) {
                                SettingsToggleRow(title: "Notifications", isOn: $workoutReminders)
                                SettingsToggleRow(title: "Dark Mode", isOn: $darkMode)
                                SettingsRow(title: "Data & Privacy", value: nil, hasArrow: true)
                                SettingsRow(title: "About", value: nil, hasArrow: true)
                            }
                        }
                    }
                    
                    // LOG OUT BUTTON CARD
                    SettingsCard {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color(hex: "FF3B30"))
                                
                                Text("Log Out")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color(hex: "FF3B30"))
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
        .background(Color.white)
    }
}

// MARK: - Settings Card

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let title: String
    let value: String?
    let hasArrow: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.system(size: 17.5, weight: .regular))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .font(.system(size: 17.5, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .padding(.trailing, hasArrow ? 8 : 0)
            }
            
            if hasArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "C7C7CC"))
                    .offset(y: 0.5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Settings Title Subtitle Row

struct SettingsTitleSubtitleRow: View {
    let title: String
    let subtitle: String
    let hasArrow: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17.5, weight: .regular))
                    .foregroundColor(Color(hex: "1C1C1E"))
                
                Text(subtitle)
                    .font(.system(size: 15.5, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
            }
            
            Spacer()
            
            if hasArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "C7C7CC"))
                    .offset(y: 0.5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Settings Toggle Row

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.system(size: 17.5, weight: .regular))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "FF3B30"))
                .scaleEffect(0.75)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    SettingsView()
}
