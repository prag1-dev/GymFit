import React, { useState } from 'react';
import { ArrowLeft, Play, Dumbbell, BarChart3, Plus, Minus } from 'lucide-react';
import { Exercise } from './types';

interface ExerciseDetailProps {
  exercise: Exercise;
  onBack: () => void;
  onUpdateExercise?: (updatedExercise: Exercise) => void;
}

const ExerciseDetail: React.FC<ExerciseDetailProps> = ({
  exercise,
  onBack,
  onUpdateExercise,
}) => {
  const [sets, setSets] = useState(exercise.sets);
  const [reps, setReps] = useState(exercise.reps);
  const [load, setLoad] = useState(exercise.load || '');

  // Generate contextual instructions based on exercise name
  const generateInstructions = (exerciseName: string): string[] => {
    const name = exerciseName.toLowerCase();
    
    if (name.includes('press')) {
      return [
        'Set up in the proper starting position for the exercise',
        'Engage your core and maintain proper posture throughout',
        'Press the weight away from your body with controlled motion',
        'Focus on the target muscle group during each repetition',
        'Complete the full range of motion for maximum effectiveness',
      ];
    } else if (name.includes('squat')) {
      return [
        'Stand with feet shoulder-width apart, toes slightly pointed out',
        'Engage your core and keep your chest up throughout',
        'Lower your body by bending at the knees and hips',
        'Descend until thighs are parallel to the floor or lower',
        'Drive through your heels to return to the starting position',
      ];
    } else if (name.includes('curl')) {
      return [
        'Stand or sit with arms at your sides, holding weights',
        'Keep your elbows close to your body and core engaged',
        'Curl the weights upward by flexing your biceps',
        'Squeeze at the top of the movement',
        'Lower the weights slowly with control to the starting position',
      ];
    } else if (name.includes('plank')) {
      return [
        'Start in a push-up position with arms straight',
        'Engage your core and keep your body in a straight line',
        'Hold the position while maintaining proper form',
        'Keep your head, shoulders, hips, and ankles aligned',
        'Breathe steadily throughout the hold',
      ];
    } else {
      return [
        'Set up in the proper starting position for the exercise',
        'Engage your core and maintain proper posture throughout',
        'Perform the movement with controlled, deliberate motion',
        'Focus on the target muscle group during each repetition',
        'Complete the full range of motion for maximum effectiveness',
      ];
    }
  };

  const instructions = generateInstructions(exercise.name);

  const handleSave = () => {
    if (onUpdateExercise) {
      onUpdateExercise({
        ...exercise,
        sets,
        reps,
        load: load || undefined,
      });
    }
    onBack();
  };

  const incrementSets = () => setSets((prev) => prev + 1);
  const decrementSets = () => setSets((prev) => Math.max(1, prev - 1));

  return (
    <div className="fixed inset-0 z-50 bg-white overflow-hidden flex flex-col">
      {/* Sticky Header */}
      <div className="sticky top-0 z-10 bg-white border-b border-gray-200 px-6 py-4">
        <div className="flex items-center gap-4">
          <button
            onClick={onBack}
            className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-colors"
            aria-label="Back"
          >
            <ArrowLeft className="w-5 h-5 text-gray-700" />
          </button>
          <h1 className="text-[34px] font-semibold text-[#1C1C1E] flex-1">
            {exercise.name}
          </h1>
        </div>
      </div>

      {/* Scrollable Content */}
      <div className="flex-1 overflow-y-auto">
        <div className="max-w-[480px] mx-auto px-6 py-6">
          {/* Video Section */}
          <div className="relative aspect-video rounded-[20px] overflow-hidden mb-6 bg-[#111827]">
            <div className="absolute inset-0 bg-gradient-to-r from-[#FF3B30]/60 via-[#FF3B30]/20 to-[#FF3B30]/60" />
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <button className="w-20 h-20 rounded-full bg-white/90 flex items-center justify-center hover:bg-white transition-colors mb-3">
                <Play className="w-8 h-8 text-[#FF3B30] fill-[#FF3B30]" />
              </button>
              <p className="text-white text-sm font-medium">Video coming soon</p>
            </div>
          </div>

          {/* How to Perform */}
          <section className="mb-6">
            <h2 className="text-[22px] font-semibold text-[#1C1C1E] mb-4">
              How to Perform
            </h2>
            <div className="space-y-3">
              {instructions.map((instruction, index) => (
                <div key={index} className="flex items-start gap-3">
                  <div className="w-8 h-8 rounded-full bg-[#FF3B30] flex items-center justify-center flex-shrink-0 mt-0.5">
                    <span className="text-white text-sm font-semibold">
                      {index + 1}
                    </span>
                  </div>
                  <p className="text-[15px] text-[#1C1C1E] leading-relaxed flex-1">
                    {instruction}
                  </p>
                </div>
              ))}
            </div>
          </section>

          {/* Equipment Needed */}
          <section className="mb-6">
            <h2 className="text-[22px] font-semibold text-[#1C1C1E] mb-4">
              Equipment Needed
            </h2>
            <div className="flex flex-wrap gap-2">
              {exercise.equipment.length > 0 ? (
                exercise.equipment.map((equip, index) => (
                  <div
                    key={index}
                    className="px-3 py-2 rounded-lg bg-gray-100 flex items-center gap-2"
                  >
                    <Dumbbell className="w-4 h-4 text-[#FF3B30]" />
                    <span className="text-[15px] text-[#1C1C1E]">{equip}</span>
                  </div>
                ))
              ) : (
                <div className="px-3 py-2 rounded-lg bg-gray-100 flex items-center gap-2">
                  <Dumbbell className="w-4 h-4 text-[#FF3B30]" />
                  <span className="text-[15px] text-[#1C1C1E]">Bodyweight</span>
                </div>
              )}
            </div>
          </section>

          {/* Muscles Targeted */}
          <section className="mb-6">
            <h2 className="text-[22px] font-semibold text-[#1C1C1E] mb-4">
              Muscles Targeted
            </h2>
            <div className="bg-gray-100 rounded-[20px] p-6 mb-4">
              {/* SVG Body Diagram - Front View */}
              <svg
                viewBox="0 0 200 400"
                className="w-full max-w-[200px] mx-auto"
                xmlns="http://www.w3.org/2000/svg"
              >
                {/* Head */}
                <ellipse cx="100" cy="40" rx="25" ry="30" fill="#E5E5E5" />
                
                {/* Torso */}
                <rect x="70" y="70" width="60" height="120" rx="10" fill="#E5E5E5" />
                
                {/* Arms */}
                <rect x="30" y="80" width="25" height="80" rx="12" fill="#E5E5E5" />
                <rect x="145" y="80" width="25" height="80" rx="12" fill="#E5E5E5" />
                
                {/* Legs */}
                <rect x="75" y="190" width="20" height="100" rx="10" fill="#E5E5E5" />
                <rect x="105" y="190" width="20" height="100" rx="10" fill="#E5E5E5" />
                
                {/* Highlight muscles based on exercise.muscles */}
                {exercise.muscles.map((muscle) => {
                  const muscleMap: Record<string, { x: number; y: number; width: number; height: number }> = {
                    'abs': { x: 70, y: 100, width: 60, height: 40 },
                    'chest': { x: 70, y: 80, width: 60, height: 30 },
                    'biceps': { x: 30, y: 90, width: 25, height: 40 },
                    'triceps': { x: 145, y: 90, width: 25, height: 40 },
                    'shoulders': { x: 60, y: 70, width: 80, height: 20 },
                    'quads': { x: 75, y: 200, width: 50, height: 50 },
                    'hamstrings': { x: 75, y: 250, width: 50, height: 40 },
                    'calves': { x: 75, y: 280, width: 50, height: 30 },
                  };
                  
                  const muscleLower = muscle.toLowerCase();
                  const position = muscleMap[muscleLower];
                  
                  if (position) {
                    return (
                      <rect
                        key={muscle}
                        x={position.x}
                        y={position.y}
                        width={position.width}
                        height={position.height}
                        fill="#FF3B30"
                        opacity={0.8}
                      />
                    );
                  }
                  return null;
                })}
              </svg>
            </div>
            <div className="flex flex-wrap gap-2">
              {exercise.muscles.map((muscle, index) => (
                <div
                  key={index}
                  className="px-3 py-2 rounded-lg bg-[#FF3B30]/10 border border-[#FF3B30]/20"
                >
                  <span className="text-[15px] text-[#1C1C1E] font-medium">
                    {muscle}
                  </span>
                </div>
              ))}
            </div>
          </section>

          {/* Your Working Sets */}
          <section className="mb-24">
            <h2 className="text-[22px] font-semibold text-[#1C1C1E] mb-4">
              Your Working Sets
            </h2>
            <div className="bg-white border border-gray-200 rounded-[20px] overflow-hidden">
              {/* Sets Row */}
              <div className="px-4 py-4 flex items-center justify-between border-b border-gray-200">
                <div className="flex items-center gap-3">
                  <BarChart3 className="w-5 h-5 text-[#FF3B30]" />
                  <span className="text-[15px] text-[#1C1C1E] font-medium">Sets</span>
                </div>
                <div className="flex items-center gap-3">
                  <button
                    onClick={decrementSets}
                    className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-colors"
                    aria-label="Decrease sets"
                  >
                    <Minus className="w-4 h-4 text-gray-700" />
                  </button>
                  <span className="text-[15px] text-[#1C1C1E] font-semibold min-w-[24px] text-center">
                    {sets}
                  </span>
                  <button
                    onClick={incrementSets}
                    className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-colors"
                    aria-label="Increase sets"
                  >
                    <Plus className="w-4 h-4 text-gray-700" />
                  </button>
                </div>
              </div>

              {/* Reps Row */}
              <div className="px-4 py-4 flex items-center justify-between border-b border-gray-200">
                <span className="text-[15px] text-[#1C1C1E] font-medium">Reps</span>
                <input
                  type="text"
                  value={reps}
                  onChange={(e) => setReps(e.target.value)}
                  className="px-3 py-2 rounded-lg bg-gray-100 text-[15px] text-[#1C1C1E] w-24 text-right focus:outline-none focus:ring-2 focus:ring-[#FF3B30] focus:ring-offset-0"
                  placeholder="10-12"
                />
              </div>

              {/* Load Row */}
              <div className="px-4 py-4 flex items-center justify-between">
                <span className="text-[15px] text-[#1C1C1E] font-medium">Load</span>
                <input
                  type="text"
                  value={load}
                  onChange={(e) => setLoad(e.target.value)}
                  className="px-3 py-2 rounded-lg bg-gray-100 text-[15px] text-[#1C1C1E] w-32 text-right focus:outline-none focus:ring-2 focus:ring-[#FF3B30] focus:ring-offset-0"
                  placeholder="Bodyweight"
                />
              </div>
            </div>
          </section>
        </div>
      </div>

      {/* Fixed Bottom Button */}
      <div className="sticky bottom-0 bg-white border-t border-gray-200 p-6">
        <div className="max-w-[480px] mx-auto">
          <button
            onClick={handleSave}
            className="w-full bg-[#FF3B30] text-white text-[15px] font-semibold py-4 rounded-[20px] hover:bg-[#FF3B30]/90 transition-colors"
          >
            Save Changes
          </button>
        </div>
      </div>
    </div>
  );
};

export default ExerciseDetail;


