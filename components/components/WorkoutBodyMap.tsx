import React, { useState } from 'react';
import WorkoutRoutineList from './WorkoutRoutineList';
import ExerciseDetail from './ExerciseDetail';
import { Exercise } from './types';

interface WorkoutRoutine {
  id: string;
  name: string;
  exercises: Exercise[];
}

interface WorkoutBodyMapProps {
  currentRoutine: WorkoutRoutine;
  setCurrentRoutine: (routine: WorkoutRoutine) => void;
}

const WorkoutBodyMap: React.FC<WorkoutBodyMapProps> = ({
  currentRoutine,
  setCurrentRoutine,
}) => {
  const [selectedExercise, setSelectedExercise] = useState<Exercise | null>(null);

  const handleExerciseClick = (exercise: Exercise) => {
    setSelectedExercise(exercise);
  };

  const handleUpdateExercise = (updatedExercise: Exercise) => {
    const updatedExercises = currentRoutine.exercises.map((e) =>
      e.id === updatedExercise.id ? updatedExercise : e
    );
    setCurrentRoutine({ ...currentRoutine, exercises: updatedExercises });
  };

  const handleDeleteExercise = (exerciseId: string) => {
    const updatedExercises = currentRoutine.exercises.filter(
      (e) => e.id !== exerciseId
    );
    setCurrentRoutine({ ...currentRoutine, exercises: updatedExercises });
  };

  if (selectedExercise) {
    return (
      <ExerciseDetail
        exercise={selectedExercise}
        onBack={() => setSelectedExercise(null)}
        onUpdateExercise={handleUpdateExercise}
      />
    );
  }

  return (
    <div className="max-w-[480px] mx-auto">
      <WorkoutRoutineList
        exercises={currentRoutine.exercises}
        onExerciseClick={handleExerciseClick}
        onDeleteExercise={handleDeleteExercise}
      />
    </div>
  );
};

export default WorkoutBodyMap;


