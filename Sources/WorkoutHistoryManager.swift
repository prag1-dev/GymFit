//
//  WorkoutHistoryManager.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import Foundation
import Combine

class WorkoutHistoryManager: ObservableObject {
    static let shared = WorkoutHistoryManager()
    
    private let userDefaults = UserDefaults.standard
    private let savedWorkoutsKey = "savedWorkouts"
    
    @Published var savedWorkouts: [SavedWorkout] = []
    
    private init() {
        loadWorkouts()
        // Always ensure sample workouts exist for demo purposes
        ensureSampleWorkouts()
    }
    
    private func ensureSampleWorkouts() {
        let calendar = Calendar.current
        var needsSave = false
        
        // November 10, 2025 - Chest Workout
        if let nov10 = calendar.date(from: DateComponents(year: 2025, month: 11, day: 10)) {
            let hasNov10 = savedWorkouts.contains { calendar.isDate($0.date, inSameDayAs: nov10) }
            if !hasNov10 {
                let chestWorkout = Workout(
                    warmup: [],
                    mainWorkout: [
                        Exercise(name: "Bench Press", sets: 4, reps: 8, restSeconds: 120, instructions: "Lie on bench, lower bar to chest, press up"),
                        Exercise(name: "Incline Dumbbell Press", sets: 3, reps: 10, restSeconds: 90, instructions: "Incline bench, press dumbbells up"),
                        Exercise(name: "Cable Fly", sets: 3, reps: 12, restSeconds: 60, instructions: "Cable crossover fly movement")
                    ],
                    cooldown: []
                )
                let savedWorkout1 = SavedWorkout(workout: chestWorkout, date: nov10)
                savedWorkouts.append(savedWorkout1)
                needsSave = true
            }
        }
        
        // November 12, 2025 - Back Workout
        if let nov12 = calendar.date(from: DateComponents(year: 2025, month: 11, day: 12)) {
            let hasNov12 = savedWorkouts.contains { calendar.isDate($0.date, inSameDayAs: nov12) }
            if !hasNov12 {
                let backWorkout = Workout(
                    warmup: [],
                    mainWorkout: [
                        Exercise(name: "Lat Pulldown", sets: 4, reps: 8, restSeconds: 90, instructions: "Pull bar to chest, control the negative"),
                        Exercise(name: "Barbell Row", sets: 3, reps: 8, restSeconds: 90, instructions: "Bent over row, pull to lower chest")
                    ],
                    cooldown: []
                )
                let savedWorkout2 = SavedWorkout(workout: backWorkout, date: nov12)
                savedWorkouts.append(savedWorkout2)
                needsSave = true
            }
        }
        
        if needsSave {
            persistWorkouts()
        }
    }
    
    func saveWorkout(_ workout: Workout) {
        let savedWorkout = SavedWorkout(workout: workout)
        savedWorkouts.insert(savedWorkout, at: 0) // Add to beginning (most recent first)
        persistWorkouts()
    }
    
    func deleteWorkout(_ workout: SavedWorkout) {
        savedWorkouts.removeAll { $0.id == workout.id }
        persistWorkouts()
    }
    
    func deleteAllWorkouts() {
        savedWorkouts.removeAll()
        persistWorkouts()
    }
    
    private func persistWorkouts() {
        if let encoded = try? JSONEncoder().encode(savedWorkouts) {
            userDefaults.set(encoded, forKey: savedWorkoutsKey)
        }
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: savedWorkoutsKey),
           let decoded = try? JSONDecoder().decode([SavedWorkout].self, from: data) {
            savedWorkouts = decoded.sorted { $0.date > $1.date } // Most recent first
        }
    }
}

