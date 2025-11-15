<?php
namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class AttendanceResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'student_id' => $this->student_id,
            'student' => $this->whenLoaded('student', function () {
                return [
                    'id' => $this->student->id,
                    'name' => $this->student->name,
                    'student_id' => $this->student->student_id,
                    'class' => $this->student->class,
                    'section' => $this->student->section,
                ];
            }),
            'date' => $this->date->toDateString(),
            'status' => $this->status,
            'note' => $this->note,
            'recorded_by' => $this->recorded_by,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
