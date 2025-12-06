//
//  WorkoutDisplayView.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI

struct WorkoutDisplayView: View {
    let workout: Workout
    var isFromHistory: Bool = false
    var savedWorkout: SavedWorkout? = nil
    
    @StateObject private var historyManager = WorkoutHistoryManager.shared
    @State private var showSaveConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var selectedTab: ViewTab = .workout
    @State private var selectedExercise: Exercise? = nil
    @State private var showExerciseDetail = false
    @Environment(\.dismiss) private var dismiss
    
    private var workoutId: String {
        savedWorkout?.id.uuidString ?? UUID().uuidString
    }
    
    enum ViewTab {
        case workout
        case chat
    }
    
    var body: some View {
        Group {
            if isFromHistory {
                historyWorkoutView
            } else {
                newWorkoutView
            }
        }
        .navigationTitle(isFromHistory ? "" : "Your Workout")
#if !os(macOS)
        .navigationBarTitleDisplayMode(isFromHistory ? .inline : .large)
        .navigationBarBackButtonHidden(isFromHistory)
        .toolbar {
            if isFromHistory {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "FF3B30"))
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        HapticFeedback.impact(style: .medium)
                        showSaveConfirmation = true
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
#endif
        .alert("Workout Saved", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your workout has been saved to history!")
        }
        .alert("Delete Workout", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let savedWorkout = savedWorkout {
                    historyManager.deleteWorkout(savedWorkout)
                    HapticFeedback.notification(type: .warning)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this workout from your history?")
        }
        .onChange(of: showSaveConfirmation) {
            if showSaveConfirmation {
                historyManager.saveWorkout(workout)
                HapticFeedback.notification(type: .success)
            }
        }
        .fullScreenCover(isPresented: $showExerciseDetail) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise, primaryMuscle: nil, secondaryMuscles: [])
            }
        }
    }
    
    private var historyWorkoutView: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    // Title and Date
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workoutTitle)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        Text(displayDateWithTime)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(hex: "6E6E73"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Three Stat Cards
                HStack(spacing: 12) {
                    PremiumStatCard(
                        icon: "flame.fill",
                        value: "\(estimatedCalories)",
                        label: "Calories",
                        iconColor: Color(hex: "FF3B30")
                    )
                    
                    PremiumStatCard(
                        icon: "clock.fill",
                        value: "\(estimatedDuration)",
                        label: "Minutes",
                        iconColor: Color(hex: "0A84FF")
                    )
                    
                    PremiumStatCard(
                        icon: "dumbbell.fill",
                        value: "\(allExercises.count)",
                        label: "Exercises",
                        iconColor: Color(hex: "AF52DE")
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Body Parts Worked Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Body Parts Worked")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                        .padding(.horizontal, 24)
                    
                    VStack(spacing: 24) {
                        // Front/Back Toggle (Custom Pill Switcher)
                        ZStack {
                            // Background
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(hex: "F2F2F2"))
                                .frame(width: 200, height: 36)
                            
                            // Active segment
                            HStack(spacing: 0) {
                                if isFrontView {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color(hex: "FF3B30"))
                                        .frame(width: 100, height: 36)
                                        .offset(x: -50)
                                } else {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color(hex: "FF3B30"))
                                        .frame(width: 100, height: 36)
                                        .offset(x: 50)
                                }
                            }
                            
                            // Buttons
                            HStack(spacing: 0) {
                                Button(action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isFrontView = true
                                    }
                                }) {
                                    Text("Front")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(isFrontView ? .white : Color(hex: "1C1C1E"))
                                        .frame(width: 100, height: 36)
                                }
                                
                                Button(action: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        isFrontView = false
                                    }
                                }) {
                                    Text("Back")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(!isFrontView ? .white : Color(hex: "1C1C1E"))
                                        .frame(width: 100, height: 36)
                                }
                            }
                        }
                        .frame(width: 200, height: 36)
                        
                        // Body Image
                        ZStack {
                            Image(isFrontView ? "body-front" : "body-back")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 300)
                            
                            // Muscle group overlays
                            ForEach(musclesWorked, id: \.self) { muscle in
                                MuscleHighlight(muscleGroup: muscle, isFront: isFrontView)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Muscle Chips (Centered)
                        HStack(spacing: 8) {
                            ForEach(musclesWorked, id: \.self) { muscle in
                                MuscleChip(name: muscle)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)
                
                // Exercises Completed Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Exercises Completed")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                        .padding(.horizontal, 24)
                    
                    ForEach(Array(allExercises.enumerated()), id: \.offset) { index, exercise in
                        PremiumExerciseCard(exercise: exercise)
                            .onTapGesture {
                                HapticFeedback.impact(style: .light)
                                selectedExercise = exercise
                                showExerciseDetail = true
                            }
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .background(Color.white)
    }
    
    @State private var isFrontView = true
    
    private var newWorkoutView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Warmup Section
                if !workout.warmup.isEmpty {
                    WorkoutSection(title: "Warmup", exercises: workout.warmup, color: .green)
                }
                
                // Main Workout Section
                if !workout.mainWorkout.isEmpty {
                    WorkoutSection(title: "Main Workout", exercises: workout.mainWorkout, color: .blue)
                }
                
                // Cooldown Section
                if !workout.cooldown.isEmpty {
                    WorkoutSection(title: "Cooldown", exercises: workout.cooldown, color: .orange)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Computed Properties for History View
    
    private var allExercises: [Exercise] {
        workout.warmup + workout.mainWorkout + workout.cooldown
    }
    
    private var workoutTitle: String {
        guard savedWorkout != nil else { return "Workout" }
        let allExercises = workout.warmup + workout.mainWorkout + workout.cooldown
        
        if allExercises.isEmpty { return "Workout" }
        
        let firstExercise = allExercises[0].name.lowercased()
        if firstExercise.contains("chest") || firstExercise.contains("bench") {
            if workout.mainWorkout.contains(where: { $0.name.lowercased().contains("tricep") }) {
                return "Chest & Triceps"
            }
            return "Chest"
        }
        if firstExercise.contains("leg") || firstExercise.contains("squat") {
            return "Leg Day"
        }
        if firstExercise.contains("back") || firstExercise.contains("row") || firstExercise.contains("pull") {
            if workout.mainWorkout.contains(where: { $0.name.lowercased().contains("bicep") }) {
                return "Back & Biceps"
            }
            return "Back"
        }
        if firstExercise.contains("shoulder") {
            return "Shoulders"
        }
        
        return "Full Body"
    }
    
    private var displayDate: String {
        guard let savedWorkout = savedWorkout else { return "" }
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
    
    private var displayDateWithTime: String {
        guard let savedWorkout = savedWorkout else { return "" }
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let dateString: String
        if calendar.isDateInToday(savedWorkout.date) {
            dateString = "Today"
        } else if calendar.isDateInYesterday(savedWorkout.date) {
            dateString = "Yesterday"
        } else {
            dateString = dateFormatter.string(from: savedWorkout.date)
        }
        
        return "\(dateString) • \(timeFormatter.string(from: savedWorkout.date))"
    }
    
    private var musclesWorked: [String] {
        var groups: Set<String> = []
        for exercise in allExercises {
            let name = exercise.name.lowercased()
            if name.contains("chest") || name.contains("bench") || name.contains("push") {
                groups.insert("Chest")
            }
            if name.contains("back") || name.contains("pull") || name.contains("row") || name.contains("lat") {
                groups.insert("Back")
                if name.contains("lat") {
                    groups.insert("Lats")
                }
            }
            if name.contains("bicep") || name.contains("curl") {
                groups.insert("Biceps")
            }
            if name.contains("tricep") || name.contains("extension") {
                groups.insert("Triceps")
            }
            if name.contains("leg") || name.contains("squat") || name.contains("quad") || name.contains("hamstring") {
                groups.insert("Legs")
            }
            if name.contains("shoulder") || name.contains("deltoid") {
                groups.insert("Shoulders")
            }
            if name.contains("core") || name.contains("ab") || name.contains("plank") {
                groups.insert("Core")
            }
        }
        return Array(groups).sorted()
    }
    
    private var estimatedDuration: Int {
        let totalExercises = workout.warmup.count + workout.mainWorkout.count + workout.cooldown.count
        let baseTime = totalExercises * 5
        let restTime = workout.mainWorkout.reduce(0) { $0 + $1.restSeconds } / 60
        return baseTime + restTime
    }
    
    private var estimatedCalories: Int {
        estimatedDuration * 8
    }
}

struct WorkoutSection: View {
    let title: String
    let exercises: [Exercise]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .padding(.bottom, 4)
            
            ForEach(Array(exercises.enumerated()), id: \.offset) { index, exercise in
                ExerciseCard(exercise: exercise, number: index + 1, color: color)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [color.opacity(0.12), color.opacity(0.06)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(color.opacity(0.2), lineWidth: 1.5)
        )
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    let number: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(number). \(exercise.name)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "number.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(color)
                    Text("\(exercise.sets) sets")
                        .fontWeight(.medium)
                }
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(color)
                    Text("\(exercise.reps) reps")
                        .fontWeight(.medium)
                }
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(color)
                    Text("\(exercise.restSeconds)s rest")
                        .fontWeight(.medium)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if !exercise.instructions.isEmpty {
                Text(exercise.instructions)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
#if canImport(UIKit)
        .background(Color(UIColor.systemBackground))
#elseif canImport(AppKit)
        .background(Color(NSColor.windowBackgroundColor))
#else
        .background(Color.background)
#endif
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: color.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Premium Workout Components

struct PremiumStatCard: View {
    let icon: String
    let value: String
    let label: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "6E6E73"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct MuscleChip: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(hex: "FF3B30"))
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Color(hex: "FFECEC"))
            .cornerRadius(20)
    }
}

struct PremiumExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 12) {
            // Check Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "FF3B30"))
            
            // Exercise Info
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                
                Text("\(exercise.sets) sets × \(exercise.reps) reps")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
                
                if !exercise.instructions.isEmpty {
                    Text(exercise.instructions)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                        .padding(.top, 2)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationView {
        WorkoutDisplayView(workout: Workout(
            warmup: [
                Exercise(name: "Light Jog", sets: 1, reps: 5, restSeconds: 0, instructions: "Jog lightly for 5 minutes to warm up your muscles.")
            ],
            mainWorkout: [
                Exercise(name: "Push-ups", sets: 3, reps: 12, restSeconds: 60, instructions: "Start in plank position, lower your body until chest nearly touches floor, then push back up.")
            ],
            cooldown: [
                Exercise(name: "Stretching", sets: 1, reps: 1, restSeconds: 0, instructions: "Stretch all major muscle groups for 5 minutes.")
            ]
        ))
    }
}

