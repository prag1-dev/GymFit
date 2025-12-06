//
//  TabBarView.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/16/25.
//

import SwiftUI

// MARK: - Tab Enum

enum Tab {
    case workout
    case history
    case coach
    case calendar
    case settings
}

// MARK: - Color Helpers

private extension Color {
    static let tabActiveRed    = Color(red: 1.0, green: 0.231, blue: 0.188)          // #FF3B30
    static let tabInactiveGray = Color(red: 0.431, green: 0.431, blue: 0.451)       // #6E6E73
    static let tabLightGray    = Color(red: 0.949, green: 0.949, blue: 0.969)       // #F2F2F7
}

// MARK: - Main Tab Bar

struct TabBarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                iconActive: "dumbbell.fill",
                iconInactive: "dumbbell",
                title: "Workout",
                isActive: selectedTab == .workout
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .workout
                }
            }
            
            TabButton(
                iconActive: "clock.fill",
                iconInactive: "clock",
                title: "History",
                isActive: selectedTab == .history
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .history
                }
            }
            
            AICoachTabButton(isActive: selectedTab == .coach) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .coach
                }
            }
            
            TabButton(
                iconActive: "calendar",
                iconInactive: "calendar",
                title: "Calendar",
                isActive: selectedTab == .calendar
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .calendar
                }
            }
            
            TabButton(
                iconActive: "gearshape.fill",
                iconInactive: "gearshape",
                title: "Settings",
                isActive: selectedTab == .settings
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .settings
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6) // slim bar height
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 0) // Tab bar at bottom edge
    }
}

// MARK: - Standard Tab Button

private struct TabButton: View {
    let iconActive: String
    let iconInactive: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 6) {
                Image(systemName: isActive ? iconActive : iconInactive)
                    .renderingMode(.template)
                    .font(.system(size: 24))
                    .foregroundColor(isActive ? .tabActiveRed : .tabInactiveGray)
                
                Text(title)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(isActive ? .tabActiveRed : .tabInactiveGray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.top, 4)              // nudge icon+label slightly down
            .frame(height: 60)           // fixed vertical height for all tabs
            .frame(maxWidth: .infinity)  // equal width distribution
        }
        .buttonStyle(.plain)
    }
}

// MARK: - AI Coach Center Button

private struct AICoachTabButton: View {
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center, spacing: 6) {
                Image(systemName: "sparkles")
                    .renderingMode(.template)
                    .font(.system(size: 24))
                    .foregroundColor(isActive ? .tabActiveRed : .tabInactiveGray)
                
                Text("AI Coach")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(isActive ? .tabActiveRed : .tabInactiveGray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.top, 4)              // match standard tabs
            .frame(height: 60)           // match other tabs
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.tabLightGray)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

struct TabBarView_Previews: PreviewProvider {
    @State static var tab: Tab = .coach
    
    static var previews: some View {
        VStack {
            Spacer()
            TabBarView(selectedTab: $tab)
        }
        .background(Color.tabLightGray.ignoresSafeArea())
        .previewLayout(.sizeThatFits)
    }
}

