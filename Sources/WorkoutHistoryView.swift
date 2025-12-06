//
//  WorkoutHistoryView.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @StateObject private var historyManager = WorkoutHistoryManager.shared
    @State private var selectedWorkout: SavedWorkout?
    @State private var showWorkoutDetails = false
    
    private var monthlyStats: (workouts: Int, totalTime: Double, calories: Int) {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.dateInterval(of: .month, for: now)!.start
        let monthEnd = calendar.dateInterval(of: .month, for: now)!.end
        
        let monthWorkouts = historyManager.savedWorkouts.filter { workout in
            workout.date >= monthStart && workout.date < monthEnd
        }
        
        let workouts = monthWorkouts.count
        let totalTime = monthWorkouts.reduce(0.0) { total, savedWorkout in
            let workout = savedWorkout.workout
            let totalExercises = workout.warmup.count + workout.mainWorkout.count + workout.cooldown.count
            let estimatedMinutes = totalExercises * 5 + (workout.mainWorkout.reduce(0) { $0 + $1.restSeconds }) / 60
            return total + Double(estimatedMinutes) / 60.0
        }
        let calories = monthWorkouts.reduce(0) { total, savedWorkout in
            let workout = savedWorkout.workout
            let totalExercises = workout.warmup.count + workout.mainWorkout.count + workout.cooldown.count
            let estimatedMinutes = totalExercises * 5 + (workout.mainWorkout.reduce(0) { $0 + $1.restSeconds }) / 60
            return total + (estimatedMinutes * 8)
        }
        
        return (workouts, totalTime, calories)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Workout History")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Text("Track your fitness journey")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Monthly Summary Card
                MonthlySummaryCard(stats: monthlyStats)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                // Workout List
                if historyManager.savedWorkouts.isEmpty {
                    EmptyStateView()
                        .padding(.top, 60)
                } else {
                    VStack(spacing: 12) {
                        ForEach(historyManager.savedWorkouts) { savedWorkout in
                            WorkoutHistoryCard(savedWorkout: savedWorkout)
                                .onTapGesture {
                                    HapticFeedback.impact(style: .light)
                                    selectedWorkout = savedWorkout
                                    showWorkoutDetails = true
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color.white)
        .navigationDestination(isPresented: $showWorkoutDetails) {
            if let workout = selectedWorkout {
                WorkoutDisplayView(workout: workout.workout, isFromHistory: true, savedWorkout: workout)
            }
        }
    }
}

// MARK: - Monthly Summary Card

struct MonthlySummaryCard: View {
    let stats: (workouts: Int, totalTime: Double, calories: Int)
    
    var body: some View {
        HStack(spacing: 0) {
            StatColumn(value: "\(stats.workouts)", label: "Workouts")
            StatColumn(value: String(format: "%.1fh", stats.totalTime), label: "Total Time")
            StatColumn(value: formatCalories(stats.calories), label: "Calories")
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func formatCalories(_ calories: Int) -> String {
        if calories >= 1000 {
            return String(format: "%.1fk", Double(calories) / 1000.0)
        }
        return "\(calories)"
    }
}

struct StatColumn: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 23, weight: .semibold))
                .foregroundColor(Color(hex: "FF3B30"))
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Workout History Card

struct WorkoutHistoryCard: View {
    let savedWorkout: SavedWorkout
    
    private var muscleGroup: String {
        let workout = savedWorkout.workout
        let allExercises = workout.warmup + workout.mainWorkout + workout.cooldown
        
        for exercise in allExercises {
            let name = exercise.name.lowercased()
            if name.contains("chest") || name.contains("bench") || name.contains("push") {
                return "chest"
            }
            if name.contains("back") || name.contains("pull") || name.contains("row") {
                return "back"
            }
            if name.contains("leg") || name.contains("squat") || name.contains("quad") || name.contains("hamstring") {
                return "legs"
            }
            if name.contains("shoulder") || name.contains("deltoid") {
                return "shoulders"
            }
        }
        return "chest" // default
    }
    
    private var muscleColors: (bg: String, fg: String) {
        switch muscleGroup {
        case "chest":
            return ("#FFE5E5", "#FF4D4D")
        case "legs":
            return ("#E6FBE6", "#34C759")
        case "back":
            return ("#E5F0FF", "#0A84FF")
        case "shoulders":
            return ("#FFF7E0", "#FFB300")
        default:
            return ("#FFE5E5", "#FF4D4D")
        }
    }
    
    private var workoutTitle: String {
        let workout = savedWorkout.workout
        let allExercises = workout.warmup + workout.mainWorkout + workout.cooldown
        
        // Try to extract a meaningful title
        if allExercises.isEmpty { return "Workout" }
        
        let firstExercise = allExercises[0].name.lowercased()
        if firstExercise.contains("chest") || firstExercise.contains("bench") {
            if firstExercise.contains("tricep") || workout.mainWorkout.contains(where: { $0.name.lowercased().contains("tricep") }) {
                return "Chest & Triceps"
            }
            return "Chest"
        }
        if firstExercise.contains("leg") || firstExercise.contains("squat") {
            return "Leg Day"
        }
        if firstExercise.contains("back") || firstExercise.contains("row") || firstExercise.contains("pull") {
            if firstExercise.contains("bicep") || workout.mainWorkout.contains(where: { $0.name.lowercased().contains("bicep") }) {
                return "Back & Biceps"
            }
            return "Back"
        }
        if firstExercise.contains("shoulder") {
            return "Shoulders"
        }
        
        return "Full Body"
    }
    
    private var estimatedDuration: Int {
        let workout = savedWorkout.workout
        let totalExercises = workout.warmup.count + workout.mainWorkout.count + workout.cooldown.count
        let baseTime = totalExercises * 5
        let restTime = workout.mainWorkout.reduce(0) { $0 + $1.restSeconds } / 60
        return baseTime + restTime
    }
    
    private var estimatedCalories: Int {
        estimatedDuration * 8
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: savedWorkout.date)
    }
    
    private var displayDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(savedWorkout.date) {
            return "Today"
        } else if calendar.isDateInYesterday(savedWorkout.date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: savedWorkout.date)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Colored Icon Circle
            ZStack {
                Circle()
                    .fill(Color(hex: muscleColors.bg))
                    .frame(width: 56, height: 56)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: muscleColors.fg))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(workoutTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Spacer()
                    
                    Text(displayDate)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                }
                
                Text(timeString)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
                
                HStack(spacing: 4) {
                    Text("•")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "FF3B30"))
                    Text("\(estimatedDuration) min")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "FF3B30"))
                    
                    Text("•")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "FF3B30"))
                    Text("\(estimatedCalories) kcal")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "FF3B30"))
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.badge.xmark")
                .font(.system(size: 64))
                .foregroundColor(Color(hex: "8E8E93").opacity(0.5))
            
            Text("No Workouts Yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            Text("Complete and save workouts to see them here")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "6E6E73"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    WorkoutHistoryView()
}
