import React, { useState } from 'react';
import { MoreVertical, Trash2 } from 'lucide-react';
import { Exercise } from './types';

interface WorkoutRoutineListProps {
  exercises: Exercise[];
  onExerciseClick: (exercise: Exercise) => void;
  onDeleteExercise?: (exerciseId: string) => void;
}

const WorkoutRoutineList: React.FC<WorkoutRoutineListProps> = ({
  exercises,
  onExerciseClick,
  onDeleteExercise,
}) => {
  const [openMenuId, setOpenMenuId] = useState<string | null>(null);

  const handleMenuClick = (e: React.MouseEvent, exerciseId: string) => {
    e.stopPropagation();
    setOpenMenuId(openMenuId === exerciseId ? null : exerciseId);
  };

  const handleDelete = (e: React.MouseEvent, exerciseId: string) => {
    e.stopPropagation();
    if (onDeleteExercise) {
      onDeleteExercise(exerciseId);
    }
    setOpenMenuId(null);
  };

  const handleCardClick = (exercise: Exercise) => {
    if (openMenuId) {
      setOpenMenuId(null);
      return;
    }
    onExerciseClick(exercise);
  };

  return (
    <div className="space-y-3 px-6 pb-6">
      {exercises.map((exercise) => (
        <div
          key={exercise.id}
          onClick={() => handleCardClick(exercise)}
          className="h-[120px] bg-white rounded-2xl shadow-[0px_2px_12px_rgba(0,0,0,0.08)] flex items-center gap-4 px-4 cursor-pointer hover:shadow-[0px_4px_16px_rgba(0,0,0,0.12)] transition-shadow"
        >
          {/* Left: Image Placeholder */}
          <div className="w-[88px] h-[88px] rounded-xl bg-gradient-to-br from-[#FF3B30]/10 to-[#FF3B30]/5 border border-[#FF3B30]/20 flex-shrink-0" />

          {/* Middle: Exercise Info */}
          <div className="flex-1 min-w-0">
            <h3 className="text-base font-semibold text-[#1C1C1E] mb-1 truncate">
              {exercise.name}
            </h3>
            <p className="text-sm text-[#6B6B6B] mb-2">
              {exercise.sets} sets × {exercise.reps} reps
              {exercise.load && ` • ${exercise.load}`}
            </p>
            <div className="flex flex-wrap gap-1.5">
              {exercise.muscles.slice(0, 2).map((muscle, index) => (
                <span
                  key={index}
                  className="px-2 py-0.5 rounded-md bg-[#FF3B30]/10 text-[#FF3B30] text-xs font-medium"
                >
                  {muscle}
                </span>
              ))}
              {exercise.muscles.length > 2 && (
                <span className="px-2 py-0.5 rounded-md bg-gray-100 text-[#6B6B6B] text-xs font-medium">
                  +{exercise.muscles.length - 2}
                </span>
              )}
            </div>
          </div>

          {/* Right: Menu Button */}
          <div className="relative flex-shrink-0">
            <button
              onClick={(e) => handleMenuClick(e, exercise.id)}
              className="w-8 h-8 rounded-full flex items-center justify-center hover:bg-gray-100 transition-colors"
              aria-label="More options"
            >
              <MoreVertical className="w-5 h-5 text-[#6B6B6B]" />
            </button>

            {/* Dropdown Menu */}
            {openMenuId === exercise.id && (
              <>
                <div
                  className="fixed inset-0 z-10"
                  onClick={(e) => {
                    e.stopPropagation();
                    setOpenMenuId(null);
                  }}
                />
                <div className="absolute right-0 top-10 z-20 bg-white rounded-lg shadow-lg border border-gray-200 min-w-[120px] overflow-hidden">
                  {onDeleteExercise && (
                    <button
                      onClick={(e) => handleDelete(e, exercise.id)}
                      className="w-full px-4 py-3 flex items-center gap-2 text-[#FF3B30] hover:bg-red-50 transition-colors text-sm font-medium"
                    >
                      <Trash2 className="w-4 h-4" />
                      Delete
                    </button>
                  )}
                </div>
              </>
            )}
          </div>
        </div>
      ))}
    </div>
  );
};

export default WorkoutRoutineList;


