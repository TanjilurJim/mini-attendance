<?php

namespace Database\Factories;
use App\Models\Student;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Student>
 */
class StudentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Student::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->name(),
            'student_id' => 'S-' . $this->faker->unique()->numberBetween(1000, 9999),
            'class' => $this->faker->randomElement(['6','7','8','9','10']),
            'section' => $this->faker->randomElement(['A','B','C']),
            'photo' => null,
        ];
    }
}
