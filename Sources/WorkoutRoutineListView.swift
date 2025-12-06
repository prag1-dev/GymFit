//
//  WorkoutRoutineListView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

struct WorkoutRoutine: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let duration: Int // in minutes
    let exercises: [Exercise]
}

struct WorkoutRoutineListView: View {
    let routine: WorkoutRoutine
    @State private var selectedExercise: Exercise? = nil
    @State private var showExerciseDetail = false
    @State private var showMenuForExercise: Exercise? = nil
    @State private var showMenuDialog = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(routine.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    // Category Tag
                    Text(routine.category)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "6E6E73"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "F2F2F7"))
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Summary Card
                WorkoutSummaryCard(
                    duration: routine.duration,
                    exerciseCount: routine.exercises.count,
                    onRefresh: {
                        HapticFeedback.impact(style: .light)
                        // TODO: Implement refresh logic
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Exercise Cards
                VStack(spacing: 12) {
                    ForEach(routine.exercises) { exercise in
                        WorkoutRoutineExerciseCard(
                            exercise: exercise,
                            onTap: {
                                HapticFeedback.impact(style: .light)
                                selectedExercise = exercise
                                showExerciseDetail = true
                            },
                            onMenuTap: {
                                HapticFeedback.impact(style: .light)
                                showMenuForExercise = exercise
                                showMenuDialog = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
        .background(Color(hex: "F2F2F7"))
        .fullScreenCover(isPresented: $showExerciseDetail) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise, primaryMuscle: nil, secondaryMuscles: [])
            }
        }
        .confirmationDialog("Exercise Options", isPresented: $showMenuDialog, presenting: showMenuForExercise) { exercise in
            Button("Edit Exercise") {
                selectedExercise = exercise
                showMenuForExercise = nil
                showMenuDialog = false
                showExerciseDetail = true
            }
            Button("Remove Exercise", role: .destructive) {
                // TODO: Implement remove logic
                showMenuForExercise = nil
                showMenuDialog = false
            }
            Button("Cancel", role: .cancel) {
                showMenuForExercise = nil
                showMenuDialog = false
            }
        }
    }
}

// MARK: - Workout Summary Card

struct WorkoutSummaryCard: View {
    let duration: Int
    let exerciseCount: Int
    let onRefresh: () -> Void
    
    var body: some View {
        HStack {
            Text("\(duration) min · \(exerciseCount) \(exerciseCount == 1 ? "exercise" : "exercises")")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "6E6E73"))
            
            Spacer()
            
            Button(action: onRefresh) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .frame(width: 32, height: 32)
                    .background(Color(hex: "F2F2F7"))
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Workout Routine Exercise Card

struct WorkoutRoutineExerciseCard: View {
    let exercise: Exercise
    let onTap: () -> Void
    let onMenuTap: () -> Void
    
    // Extract equipment from exercise name or use default
    private var equipment: String {
        let name = exercise.name.lowercased()
        if name.contains("barbell") {
            return "Barbell"
        } else if name.contains("dumbbell") || name.contains("db ") {
            return "Dumbbell"
        } else if name.contains("cable") {
            return "Cable Machine"
        } else if name.contains("bodyweight") || name.contains("push-up") || name.contains("plank") {
            return "Bodyweight"
        } else {
            return "Bodyweight" // Default
        }
    }
    
    // Extract muscle groups from exercise name
    private var muscleGroups: [String] {
        let name = exercise.name.lowercased()
        var muscles: [String] = []
        
        if name.contains("chest") || name.contains("bench") || name.contains("press") {
            muscles.append("Chest")
        }
        if name.contains("bicep") || name.contains("curl") {
            muscles.append("Biceps")
        }
        if name.contains("tricep") || name.contains("extension") || name.contains("dip") {
            muscles.append("Triceps")
        }
        if name.contains("shoulder") || name.contains("deltoid") {
            muscles.append("Shoulders")
        }
        if name.contains("back") || name.contains("row") || name.contains("pull") {
            muscles.append("Back")
        }
        if name.contains("leg") || name.contains("squat") || name.contains("quad") {
            muscles.append("Legs")
        }
        if name.contains("abs") || name.contains("core") || name.contains("plank") {
            muscles.append("Abs")
        }
        
        return muscles.isEmpty ? ["Full Body"] : muscles
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Exercise Icon/Placeholder (120px square)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "FF3B30").opacity(0.1),
                                Color(hex: "FF3B30").opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "FF3B30").opacity(0.2), lineWidth: 1)
                    )
                
                // Placeholder icon
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "FF3B30").opacity(0.6))
            }
            .frame(width: 120, height: 120)
            
            // Exercise Details
            VStack(alignment: .leading, spacing: 8) {
                // Exercise Name
                Text(exercise.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                    .lineLimit(2)
                
                // Sets/Reps/Equipment inline
                Text("\(exercise.sets) sets × \(exercise.reps) reps · \(equipment)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
                
                // Muscle Tags
                if !muscleGroups.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(muscleGroups.prefix(2), id: \.self) { muscle in
                            Text(muscle)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "FF3B30"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "FF3B30").opacity(0.1))
                                .cornerRadius(8)
                        }
                        if muscleGroups.count > 2 {
                            Text("+\(muscleGroups.count - 2)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "6E6E73"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "F2F2F7"))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Three-dot menu button
            Button(action: onMenuTap) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(90))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    WorkoutRoutineListView(
        routine: WorkoutRoutine(
            title: "Chest Workout",
            category: "Chest",
            duration: 30,
            exercises: [
                Exercise(
                    name: "Push-ups",
                    sets: 3,
                    reps: 12,
                    restSeconds: 60,
                    instructions: "Start in plank position, lower your body until chest nearly touches floor, then push back up."
                ),
                Exercise(
                    name: "Barbell Bench Press",
                    sets: 4,
                    reps: 8,
                    restSeconds: 90,
                    instructions: "Lie on bench, lower barbell to chest, press up."
                )
            ]
        )
    )
}

