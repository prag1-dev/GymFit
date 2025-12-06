//
//  CalendarView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

// MARK: - Workout Entry Model

struct WorkoutEntry: Identifiable {
    let id = UUID()
    let date: Date
    let name: String
    let duration: String
    let muscleGroups: [String]
    let calories: Int?
    let notes: String?
}

// MARK: - Calendar View

struct CalendarView: View {
    @StateObject private var historyManager = WorkoutHistoryManager.shared
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var showWorkoutSheet = false
    
    private let calendar = Calendar.current
    
    // Convert SavedWorkout to WorkoutEntry for display
    private var workoutEntries: [WorkoutEntry] {
        historyManager.savedWorkouts.map { savedWorkout in
            let workout = savedWorkout.workout
            let totalExercises = workout.warmup.count + workout.mainWorkout.count + workout.cooldown.count
            
            // Estimate duration: ~5 min per exercise + rest time
            let estimatedMinutes = totalExercises * 5 + (workout.mainWorkout.reduce(0) { $0 + $1.restSeconds }) / 60
            let duration = "\(estimatedMinutes) min"
            
            // Estimate calories: ~8-10 calories per minute of workout
            let estimatedCalories = estimatedMinutes * 8
            
            // Extract muscle groups from exercise names (simplified)
            let muscleGroups = extractMuscleGroups(from: workout)
            
            return WorkoutEntry(
                date: savedWorkout.date,
                name: generateWorkoutName(from: workout),
                duration: duration,
                muscleGroups: muscleGroups,
                calories: estimatedCalories,
                notes: nil
            )
        }
    }
    
    // Helper to extract muscle groups from workout
    private func extractMuscleGroups(from workout: Workout) -> [String] {
        var groups: Set<String> = []
        let allExercises = workout.warmup + workout.mainWorkout + workout.cooldown
        
        for exercise in allExercises {
            let name = exercise.name.lowercased()
            if name.contains("chest") || name.contains("bench") || name.contains("push") {
                groups.insert("Chest")
            }
            if name.contains("back") || name.contains("pull") || name.contains("row") {
                groups.insert("Back")
            }
            if name.contains("leg") || name.contains("squat") || name.contains("quad") {
                groups.insert("Legs")
            }
            if name.contains("shoulder") || name.contains("deltoid") {
                groups.insert("Shoulders")
            }
            if name.contains("bicep") || name.contains("curl") {
                groups.insert("Biceps")
            }
            if name.contains("tricep") || name.contains("extension") {
                groups.insert("Triceps")
            }
            if name.contains("core") || name.contains("ab") || name.contains("plank") {
                groups.insert("Core")
            }
        }
        
        return Array(groups).sorted()
    }
    
    // Generate workout name from exercises
    private func generateWorkoutName(from workout: Workout) -> String {
        let mainCount = workout.mainWorkout.count
        if mainCount > 0 {
            let firstExercise = workout.mainWorkout[0].name
            if firstExercise.lowercased().contains("full body") {
                return "Full Body Workout"
            }
            return "\(mainCount) Exercise Workout"
        }
        return "Workout"
    }
    
    // Helper to check if a date has a workout
    private func hasWorkout(_ date: Date) -> Bool {
        return workoutEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private var selectedSavedWorkout: SavedWorkout? {
        guard let selectedDate = selectedDate else { return nil }
        return historyManager.savedWorkouts.first { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var monthlyStats: (workouts: Int, totalTime: Double, calories: Int) {
        let monthStart = calendar.dateInterval(of: .month, for: currentDate)!.start
        let monthEnd = calendar.dateInterval(of: .month, for: currentDate)!.end
        
        let monthWorkouts = workoutEntries.filter { workout in
            workout.date >= monthStart && workout.date < monthEnd
        }
        
        let workouts = monthWorkouts.count
        let totalTime = monthWorkouts.reduce(0.0) { total, workout in
            let timeString = workout.duration.replacingOccurrences(of: " min", with: "")
            return total + (Double(timeString) ?? 0.0) / 60.0
        }
        let calories = monthWorkouts.reduce(0) { $0 + ($1.calories ?? 0) }
        
        return (workouts, totalTime, calories)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calendar")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Text("Your workout schedule")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Calendar Card
                CalendarCard(
                    currentDate: $currentDate,
                    selectedDate: $selectedDate,
                    workouts: workoutEntries,
                    hasWorkout: hasWorkout,
                    onDateTap: { date in
                        selectedDate = date
                        showWorkoutSheet = true
                    }
                )
                .padding(.horizontal, 24)
                
                // This Month Stats Card
                ThisMonthStatsCard(stats: monthlyStats)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 100)
        }
        .background(Color.white)
        .sheet(isPresented: $showWorkoutSheet) {
            if let savedWorkout = selectedSavedWorkout {
                WorkoutDetailSheet(savedWorkout: savedWorkout)
            } else {
                EmptyWorkoutSheet(date: selectedDate ?? Date())
            }
        }
    }
}

// MARK: - Calendar Card

struct CalendarCard: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date?
    let workouts: [WorkoutEntry]
    let hasWorkout: (Date) -> Bool
    let onDateTap: (Date) -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthStart: Date {
        calendar.dateInterval(of: .month, for: currentDate)!.start
    }
    
    private var monthEnd: Date {
        calendar.dateInterval(of: .month, for: currentDate)!.end
    }
    
    private var daysInMonth: [Date?] {
        let firstDayOfWeek = calendar.component(.weekday, from: monthStart) - 1
        var days: [Date?] = Array(repeating: nil, count: firstDayOfWeek)
        
        var date = monthStart
        while date < monthEnd {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Month Navigation
            HStack {
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentDate))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Days of Week Header
            HStack(spacing: 0) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!),
                            hasWorkout: hasWorkout(date),
                            isToday: calendar.isDateInToday(date),
                            onTap: { onDateTap(date) }
                        )
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Calendar Day View

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasWorkout: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(dayNumber)")
                    .font(.system(size: 15, weight: (isSelected || isToday) ? .semibold : .regular))
                    .foregroundColor(isToday ? .white : (isSelected ? Color(hex: "1C1C1E") : Color(hex: "1C1C1E")))
                
                // Workout completion dot (appears below the date, always red unless on red background)
                if hasWorkout {
                    Circle()
                        .fill(isToday ? Color.white : Color(hex: "FF3B30"))
                        .frame(width: 4, height: 4)
                } else {
                    Spacer()
                        .frame(height: 4)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                ZStack {
                    // Priority 1: Today gets red filled circle
                    if isToday {
                        Circle()
                            .fill(Color(hex: "FF3B30"))
                            .frame(width: 32, height: 32)
                    }
                    // Priority 2: Selected date gets grey outline circle (only if not today)
                    else if isSelected {
                        Circle()
                            .stroke(Color(hex: "C7C7CC"), lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                    }
                }
            )
        }
    }
}

// MARK: - This Month Stats Card

struct ThisMonthStatsCard: View {
    let stats: (workouts: Int, totalTime: Double, calories: Int)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Month")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            HStack(spacing: 0) {
                StatItem(value: "\(stats.workouts)", label: "Workouts")
                StatItem(value: String(format: "%.1fh", stats.totalTime), label: "Total Time")
                StatItem(value: formatCalories(stats.calories), label: "Calories")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func formatCalories(_ calories: Int) -> String {
        if calories >= 1000 {
            return String(format: "%.1fk", Double(calories) / 1000.0)
        }
        return "\(calories)"
    }
}

struct StatItem: View {
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

// MARK: - Workout Detail Sheet

struct WorkoutDetailSheet: View {
    let savedWorkout: SavedWorkout
    @Environment(\.dismiss) private var dismiss
    @State private var isFrontView = true
    
    private var workout: Workout {
        savedWorkout.workout
    }
    
    private var allExercises: [Exercise] {
        workout.warmup + workout.mainWorkout + workout.cooldown
    }
    
    private var totalExercises: Int {
        allExercises.count
    }
    
    private var estimatedDuration: Int {
        // Estimate: ~5 min per exercise + rest time
        let baseTime = totalExercises * 5
        let restTime = workout.mainWorkout.reduce(0) { $0 + $1.restSeconds } / 60
        return baseTime + restTime
    }
    
    private var estimatedCalories: Int {
        estimatedDuration * 8
    }
    
    private var muscleGroups: [String] {
        var groups: Set<String> = []
        for exercise in allExercises {
            let name = exercise.name.lowercased()
            if name.contains("chest") || name.contains("bench") || name.contains("push") {
                groups.insert("Chest")
            }
            if name.contains("back") || name.contains("pull") || name.contains("row") {
                groups.insert("Back")
            }
            if name.contains("leg") || name.contains("squat") || name.contains("quad") || name.contains("hamstring") {
                groups.insert("Legs")
            }
            if name.contains("shoulder") || name.contains("deltoid") {
                groups.insert("Shoulders")
            }
            if name.contains("bicep") || name.contains("curl") {
                groups.insert("Biceps")
            }
            if name.contains("tricep") || name.contains("extension") {
                groups.insert("Triceps")
            }
            if name.contains("core") || name.contains("ab") || name.contains("plank") {
                groups.insert("Core")
            }
        }
        return Array(groups).sorted()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(hex: "C7C7CC"))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dateFormatter.string(from: savedWorkout.date))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "1C1C1E"))
                        }
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "1C1C1E"))
                                .frame(width: 32, height: 32)
                                .background(Color(hex: "F2F2F7"))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Stats Row (3 cards)
                    HStack(spacing: 12) {
                        StatCard(
                            icon: "clock.fill",
                            value: "\(estimatedDuration) min",
                            label: "Duration"
                        )
                        
                        StatCard(
                            icon: "flame.fill",
                            value: "\(estimatedCalories) cal",
                            label: "Calories"
                        )
                        
                        StatCard(
                            icon: "dumbbell.fill",
                            value: "\(totalExercises) exercises",
                            label: "Exercises"
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // Body Diagram
                    VStack(spacing: 12) {
                        // Front/Back Toggle
                        Picker("View", selection: $isFrontView) {
                            Text("Front").tag(true)
                            Text("Back").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                        
                        // Body Image with Muscle Highlights
                        ZStack {
                            Image(isFrontView ? "body-front" : "body-back")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 300)
                            
                            // Muscle group overlays
                            ForEach(muscleGroups, id: \.self) { group in
                                MuscleHighlight(muscleGroup: group, isFront: isFrontView)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    
                    // Exercises List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Exercises")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                            .padding(.horizontal, 24)
                        
                        ForEach(Array(allExercises.enumerated()), id: \.offset) { index, exercise in
                            ExerciseDetailCard(exercise: exercise, number: index + 1)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color.white)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "FF3B30"))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(hex: "6E6E73"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(hex: "F2F2F7"))
        .cornerRadius(16)
    }
}

// MARK: - Muscle Highlight

struct MuscleHighlight: View {
    let muscleGroup: String
    let isFront: Bool
    
    var body: some View {
        Group {
            switch muscleGroup.lowercased() {
            case "chest":
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "FF3B30").opacity(0.3))
                    .frame(width: 60, height: 40)
                    .offset(x: 0, y: -80)
            case "biceps":
                if isFront {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 25, height: 50)
                            .offset(x: -50, y: -40)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 25, height: 50)
                            .offset(x: 50, y: -40)
                    }
                }
            case "triceps":
                if isFront {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 20, height: 40)
                            .offset(x: -50, y: -20)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 20, height: 40)
                            .offset(x: 50, y: -20)
                    }
                } else {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 20, height: 40)
                            .offset(x: -50, y: -20)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "FF3B30").opacity(0.3))
                            .frame(width: 20, height: 40)
                            .offset(x: 50, y: -20)
                    }
                }
            case "back":
                if !isFront {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "FF3B30").opacity(0.3))
                        .frame(width: 70, height: 80)
                        .offset(x: 0, y: -60)
                }
            case "legs":
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "FF3B30").opacity(0.3))
                        .frame(width: 50, height: 60)
                        .offset(x: 0, y: 40)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "FF3B30").opacity(0.3))
                        .frame(width: 50, height: 60)
                        .offset(x: 0, y: 100)
                }
            case "shoulders":
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "FF3B30").opacity(0.3))
                        .frame(width: 30, height: 30)
                        .offset(x: -40, y: -90)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "FF3B30").opacity(0.3))
                        .frame(width: 30, height: 30)
                        .offset(x: 40, y: -90)
                }
            case "core":
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "FF3B30").opacity(0.3))
                    .frame(width: 50, height: 40)
                    .offset(x: 0, y: 0)
            default:
                EmptyView()
            }
        }
    }
}

// MARK: - Exercise Detail Card

struct ExerciseDetailCard: View {
    let exercise: Exercise
    let number: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Exercise Number
            Text("\(number)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "FF3B30"))
                .frame(width: 32, height: 32)
                .background(Color(hex: "FFEBE9"))
                .clipShape(Circle())
            
            // Exercise Info
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                
                Text("\(exercise.sets) sets × \(exercise.reps) reps")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
            }
            
            Spacer()
            
            // Checkmark (assuming completed)
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.green)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "E5E5EA"), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Empty Workout Sheet

struct EmptyWorkoutSheet: View {
    let date: Date
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "8E8E93"))
                
                Text("No workout logged for this day.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(hex: "1C1C1E"))
                    .multilineTextAlignment(.center)
                
                Text(dateFormatter.string(from: date))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "6E6E73"))
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Workout Details")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "FF3B30"))
                }
            }
#endif
        }
    }
}


#Preview {
    CalendarView()
}

