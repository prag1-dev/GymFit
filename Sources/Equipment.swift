//
//  Equipment.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/12/25.
//

import SwiftUI

// MARK: - Legacy Equipment Model (for backward compatibility)
struct Equipment: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

// Available equipment list
let defaultEquipmentList: [Equipment] = [
    Equipment(name: "Barbell", icon: "figure.strengthtraining.traditional"),
    Equipment(name: "Dumbbell", icon: "dumbbell.fill"),
    Equipment(name: "Bench", icon: "bed.double.fill"),
    Equipment(name: "Cable Machine", icon: "cable.connector"),
    Equipment(name: "Squat Rack", icon: "square.stack.3d.up.fill"),
    Equipment(name: "Pull-up Bar", icon: "figure.pull"),
    Equipment(name: "Leg Press", icon: "figure.run"),
    Equipment(name: "Smith Machine", icon: "square.stack.3d.down.fill")
]

// MARK: - Equipment Type Enum (Complete Taxonomy)
enum EquipmentType: String, CaseIterable {
    case bodyweight
    case pullUpBar
    case dipBar
    case floorMat
    
    case dumbbells
    case adjustableDumbbells
    
    case barbell
    case olympicBarbell
    case ezBar
    case trapBar
    
    case flatBench
    case inclineBench
    case declineBench
    case adjustableBench
    case smithMachine
    case preacherCurlBench
    
    case cableDual
    case cableSingle
    case cableCrossover
    case latPulldownCable
    case seatedRowCable
    case tricepCable
    
    case chestPressMachine
    case pecDeckMachine
    case inclineChestMachine
    case declineChestMachine
    
    case shoulderPressMachine
    case lateralRaiseMachine
    case rearDeltMachine
    
    case latPulldownMachine
    case seatedRowMachine
    case highRowMachine
    case pulloverMachine
    
    case bicepCurlMachine
    case tricepExtensionMachine
    case preacherCurlMachineSelectorized
    
    case legPressMachine
    case hackSquatMachine
    case legExtensionMachine
    case hamstringCurlMachine
    case hipAbductionMachine
    case hipAdductionMachine
    case gluteDriveMachine
    case calfRaiseMachine
    
    case abCrunchMachine
    case rotaryTorsoMachine
    
    case hammerStrengthChest
    case hammerStrengthIncline
    case hammerStrengthDecline
    case hammerStrengthShoulder
    case hammerStrengthRow
    case hammerStrengthHighRow
    case hammerStrengthPulldown
    case hammerStrengthLegPress
    case hammerStrengthHackSquat
    
    case resistanceBands
    case loopBands
    case cableAttachments
    case kettlebells
    case medicineBall
    case landmine
    
    case treadmill
    case stairClimber
    case rowingMachine
    case spinBike
    case elliptical
    case assaultBike
}

// MARK: - Gym Profile Presets
enum GymProfile {
    case homeBodyweight
    case homeDumbbells
    case hotel
    case commercial
    case planetFitness
}

extension GymProfile {
    var allowedEquipment: [EquipmentType] {
        switch self {
        case .homeBodyweight:
            return [.bodyweight, .floorMat, .pullUpBar]
            
        case .homeDumbbells:
            return [.bodyweight, .floorMat, .pullUpBar, .dumbbells, .adjustableBench]
            
        case .hotel:
            return [
                .bodyweight, .floorMat, .dumbbells, .adjustableBench,
                .cableDual, .treadmill
            ]
            
        case .commercial:
            return EquipmentType.allCases // full access
            
        case .planetFitness:
            return EquipmentType.allCases.filter {
                $0 != .barbell && $0 != .olympicBarbell && $0 != .trapBar
            }
        }
    }
}

// MARK: - Exercise Database
struct ExerciseDatabase {
    static let all: [String: [EquipmentType: [String]]] = [
        // MARK: - CHEST
        "chest": [
            .bodyweight: [
                "Push-ups", "Wide push-ups", "Decline push-ups", "Diamond push-ups"
            ],
            .dumbbells: [
                "Flat dumbbell press", "Incline dumbbell press", "Decline dumbbell press",
                "Dumbbell flyes", "Incline dumbbell flyes", "Dumbbell pullover"
            ],
            .barbell: [
                "Barbell bench press", "Incline barbell bench press"
            ],
            .cableCrossover: [
                "Cable chest fly (high to low)", "Cable chest fly (low to high)"
            ],
            .cableDual: [
                "Cable single-arm chest press"
            ],
            .chestPressMachine: [
                "Chest press machine"
            ],
            .pecDeckMachine: [
                "Pec deck fly"
            ],
            .hammerStrengthChest: [
                "Hammer Strength chest press"
            ],
            .hammerStrengthIncline: [
                "Hammer Strength incline press"
            ]
        ],
        
        // MARK: - SHOULDERS
        "shoulders": [
            .bodyweight: [
                "Pike push-ups", "Elevated pike press"
            ],
            .dumbbells: [
                "Front raises", "Dumbbell shoulder press", "Arnold press"
            ],
            .barbell: [
                "Barbell overhead press"
            ],
            .cableSingle: [
                "Cable front raises"
            ],
            .shoulderPressMachine: [
                "Shoulder press machine"
            ],
            .hammerStrengthShoulder: [
                "Hammer Strength shoulder press"
            ]
        ],
        
        // MARK: - BICEPS
        "biceps": [
            .bodyweight: [
                "Chin-ups", "Close-grip inverted rows"
            ],
            .dumbbells: [
                "Dumbbell curls", "Hammer curls", "Incline curls",
                "Concentration curls", "Zottman curls"
            ],
            .barbell: [
                "Barbell curls"
            ],
            .cableSingle: [
                "Single-arm cable curls", "Cable curls"
            ],
            .preacherCurlMachineSelectorized: [
                "Preacher curl machine"
            ],
            .bicepCurlMachine: [
                "Bicep curl machine"
            ]
        ],
        
        // MARK: - ABS
        "abs": [
            .bodyweight: [
                "Crunches", "Reverse crunches", "Sit-ups", "Plank",
                "Leg raises", "Hanging knee raises", "V-ups", "Hollow body hold"
            ],
            .cableDual: [
                "Cable crunch", "Cable leg raise"
            ],
            .abCrunchMachine: [
                "Ab crunch machine"
            ]
        ],
        
        // MARK: - OBLIQUES
        "obliques": [
            .bodyweight: [
                "Side plank", "Bicycle crunches", "Russian twists",
                "Heel touches", "Side V-ups"
            ],
            .dumbbells: [
                "Dumbbell side bends"
            ],
            .cableDual: [
                "Cable woodchopper (high to low)", "Cable woodchopper (low to high)"
            ],
            .rotaryTorsoMachine: [
                "Rotary torso machine"
            ],
            .landmine: [
                "Landmine twist"
            ]
        ],
        
        // MARK: - FOREARMS
        "forearms": [
            .bodyweight: [
                "Towel hangs",
                "Dead hangs",
                "Fingertip push-ups"
            ],
            .dumbbells: [
                "Dumbbell wrist curls (supinated)",
                "Dumbbell reverse wrist curls (pronated)",
                "Dumbbell hammer grip holds (timed)",
                "Zottman curls",
                "Farmer's walks"
            ],
            .barbell: [
                "Barbell wrist curl",
                "Barbell reverse wrist curl",
                "Behind-the-back wrist curl"
            ],
            .ezBar: [
                "EZ bar wrist curl",
                "EZ bar reverse wrist curl"
            ],
            .cableDual: [
                "Rope wrist curls",
                "Cable reverse wrist curls",
                "Cable pronation/supination"
            ],
            .kettlebells: [
                "Farmer's walks"
            ]
        ]
    ]
    
    // MARK: - Exercise Fetching Function
    /// Fetches exercises for selected muscle groups based on available equipment in the gym
    /// - Parameters:
    ///   - muscles: Array of selected muscle group strings (e.g., ["chest", "shoulders"])
    ///   - gym: The gym profile that determines available equipment
    /// - Returns: Deduplicated array of exercise names
    static func exercises(for muscles: [String], gym: GymProfile) -> [String] {
        let allowedEquipment = gym.allowedEquipment
        var allExercises: Set<String> = []
        
        for muscle in muscles {
            guard let muscleExercises = all[muscle] else { continue }
            
            for (equipment, exercises) in muscleExercises {
                if allowedEquipment.contains(equipment) {
                    allExercises.formUnion(exercises)
                }
            }
        }
        
        return Array(allExercises).sorted()
    }
}

// MARK: - Equipment-to-Exercises Database
/// Equipment-centric mapping: "What exercises can you do with this equipment?"
struct EquipmentExerciseDatabase {
    static let all: [EquipmentType: [String]] = [
        // MARK: - A. Bodyweight / Minimal Equipment
        .bodyweight: [
            "Push-ups",
            "Diamond push-ups",
            "Wide push-ups",
            "Pike push-ups",
            "Decline push-ups",
            "Plank",
            "Side plank",
            "Bicycle crunch",
            "Leg raises",
            "V-ups",
            "Hollow body hold",
            "Sit-ups",
            "Burpees",
            "Mountain climbers",
            "Towel hangs",
            "Dead hangs",
            "Fingertip push-ups"
        ],
        
        .pullUpBar: [
            "Pull-ups",
            "Chin-ups",
            "Hanging leg raises",
            "Toes-to-bar (scaled)",
            "Hanging knee raises",
            "Dead hangs",
            "Towel hangs"
        ],
        
        .dipBar: [
            "Dips",
            "L-sit dips",
            "Knee tuck dips"
        ],
        
        .floorMat: [
            "Crunches",
            "Reverse crunch",
            "Russian twists",
            "Heel touches",
            "Glute bridge"
        ],
        
        // MARK: - B. Dumbbells
        .dumbbells: [
            "Dumbbell shoulder press",
            "Arnold press",
            "Front raises",
            "Lateral raises",
            "Dumbbell curls",
            "Hammer curls",
            "Concentration curls",
            "Incline curls",
            "Zottman curls",
            "Goblet squat",
            "Dumbbell bench press",
            "Incline dumbbell press",
            "Decline dumbbell press",
            "Dumbbell flyes",
            "Dumbbell pullover",
            "Dumbbell side bends",
            "Dumbbell wrist curls (supinated)",
            "Dumbbell reverse wrist curls (pronated)",
            "Dumbbell hammer grip holds (timed)",
            "Farmer's walks"
        ],
        
        .adjustableDumbbells: [
            "Dumbbell shoulder press",
            "Arnold press",
            "Front raises",
            "Lateral raises",
            "Dumbbell curls",
            "Hammer curls",
            "Concentration curls",
            "Incline curls",
            "Zottman curls",
            "Goblet squat",
            "Dumbbell bench press",
            "Incline dumbbell press",
            "Decline dumbbell press",
            "Dumbbell flyes",
            "Dumbbell pullover",
            "Dumbbell side bends",
            "Dumbbell wrist curls (supinated)",
            "Dumbbell reverse wrist curls (pronated)",
            "Dumbbell hammer grip holds (timed)",
            "Farmer's walks"
        ],
        
        // MARK: - C. Barbells
        .barbell: [
            "Barbell bench press",
            "Incline barbell press",
            "Decline barbell press",
            "Barbell overhead press",
            "Barbell curl",
            "Reverse curl",
            "Barbell row",
            "Barbell wrist curl",
            "Barbell reverse wrist curl",
            "Behind-the-back wrist curl"
        ],
        
        .olympicBarbell: [
            "Barbell bench press",
            "Incline barbell press",
            "Decline barbell press",
            "Barbell overhead press",
            "Barbell curl",
            "Reverse curl",
            "Barbell row",
            "Barbell wrist curl",
            "Barbell reverse wrist curl",
            "Behind-the-back wrist curl"
        ],
        
        .ezBar: [
            "EZ bar curl",
            "EZ bar reverse curl",
            "EZ bar preacher curl",
            "EZ bar wrist curl",
            "EZ bar reverse wrist curl"
        ],
        
        .trapBar: [
            "Trap bar deadlift",
            "Trap bar shrugs"
        ],
        
        // MARK: - D. Benches & Racks
        .flatBench: [
            "Dumbbell bench press",
            "Incline dumbbell press",
            "Decline dumbbell press",
            "Dumbbell flyes",
            "Incline dumbbell flyes",
            "Barbell bench press",
            "Incline barbell press",
            "Decline barbell press",
            "Seated overhead press"
        ],
        
        .inclineBench: [
            "Incline dumbbell press",
            "Incline dumbbell flyes",
            "Incline barbell press",
            "Seated overhead press"
        ],
        
        .declineBench: [
            "Decline dumbbell press",
            "Decline barbell press"
        ],
        
        .adjustableBench: [
            "Dumbbell bench press",
            "Incline dumbbell press",
            "Decline dumbbell press",
            "Dumbbell flyes",
            "Incline dumbbell flyes",
            "Barbell bench press",
            "Incline barbell press",
            "Decline barbell press",
            "Seated overhead press"
        ],
        
        .preacherCurlBench: [
            "Preacher curl (barbell)",
            "Preacher curl (EZ bar)",
            "Preacher curl (dumbbell)"
        ],
        
        .smithMachine: [
            "Smith machine bench press",
            "Smith machine incline press",
            "Smith machine shoulder press",
            "Smith machine close-grip press"
        ],
        
        // MARK: - E. Cable Systems
        .cableDual: [
            "Cable chest fly (high → low)",
            "Cable chest fly (low → high)",
            "Cable single-arm press",
            "Cable front raise",
            "Cable curls",
            "Rope hammer curls",
            "Face pulls",
            "Cable crunch",
            "Cable woodchopper",
            "Rope wrist curls",
            "Cable reverse wrist curls",
            "Cable pronation/supination"
        ],
        
        .cableSingle: [
            "Single-arm cable curl",
            "Single-arm front raise",
            "Single-arm press"
        ],
        
        .cableCrossover: [
            "Cable crossover fly",
            "Low cable fly",
            "High cable fly"
        ],
        
        .latPulldownCable: [
            "Lat pulldown"
        ],
        
        .seatedRowCable: [
            "Seated row"
        ],
        
        .tricepCable: [
            "Tricep pushdown",
            "Overhead rope extension"
        ],
        
        // MARK: - F. Selectorized Machines
        .chestPressMachine: [
            "Chest press (horizontal)"
        ],
        
        .inclineChestMachine: [
            "Machine incline press"
        ],
        
        .declineChestMachine: [
            "Machine decline press"
        ],
        
        .pecDeckMachine: [
            "Pec deck fly",
            "Reverse pec deck (rear delts)"
        ],
        
        .shoulderPressMachine: [
            "Shoulder press machine"
        ],
        
        .lateralRaiseMachine: [
            "Machine lateral raises"
        ],
        
        .rearDeltMachine: [
            "Machine rear delt fly"
        ],
        
        .bicepCurlMachine: [
            "Bicep curl machine"
        ],
        
        .tricepExtensionMachine: [
            "Tricep extension machine"
        ],
        
        .preacherCurlMachineSelectorized: [
            "Machine preacher curl"
        ],
        
        .abCrunchMachine: [
            "Machine ab crunch"
        ],
        
        .rotaryTorsoMachine: [
            "Machine oblique twist"
        ],
        
        // MARK: - G. Plate-Loaded Machines (Hammer Strength)
        .hammerStrengthChest: [
            "HS chest press"
        ],
        
        .hammerStrengthIncline: [
            "HS incline chest press"
        ],
        
        .hammerStrengthDecline: [
            "HS decline chest press"
        ],
        
        .hammerStrengthShoulder: [
            "HS shoulder press"
        ],
        
        .hammerStrengthRow: [
            "HS low row"
        ],
        
        .hammerStrengthHighRow: [
            "HS high row"
        ],
        
        .hammerStrengthPulldown: [
            "HS pulldown"
        ],
        
        .hammerStrengthLegPress: [
            "HS leg press"
        ],
        
        .hammerStrengthHackSquat: [
            "HS hack squat"
        ],
        
        // MARK: - H. Accessories
        .resistanceBands: [
            "Band chest fly",
            "Band curls",
            "Band front raises",
            "Band plank",
            "Band woodchoppers"
        ],
        
        .loopBands: [
            "Band chest fly",
            "Band curls",
            "Band front raises",
            "Band plank",
            "Band woodchoppers"
        ],
        
        .cableAttachments: [
            // Cable attachments enable exercises but don't create unique exercises
            // Exercises are covered under cableDual, cableSingle, etc.
        ],
        
        .kettlebells: [
            "KB curls",
            "KB shoulder press",
            "Farmer's walks"
        ],
        
        .medicineBall: [
            "MB twists",
            "MB slams"
        ],
        
        .landmine: [
            "Landmine press",
            "Landmine twist"
        ],
        
        // MARK: - Cardio Equipment (for completeness)
        .treadmill: [],
        .stairClimber: [],
        .rowingMachine: [],
        .spinBike: [],
        .elliptical: [],
        .assaultBike: []
    ]
    
    /// Returns all exercises available for a given equipment type
    /// - Parameter equipment: The equipment type to query
    /// - Returns: Array of exercise names, or empty array if no exercises found
    static func exercises(for equipment: EquipmentType) -> [String] {
        return all[equipment] ?? []
    }
    
    /// Returns all exercises available for multiple equipment types
    /// - Parameter equipment: Array of equipment types
    /// - Returns: Deduplicated, sorted array of all exercises
    static func exercises(for equipment: [EquipmentType]) -> [String] {
        var allExercises: Set<String> = []
        
        for eq in equipment {
            if let exercises = all[eq] {
                allExercises.formUnion(exercises)
            }
        }
        
        return Array(allExercises).sorted()
    }
}
