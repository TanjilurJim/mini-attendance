<?php
namespace App\Http\Requests;
use Illuminate\Foundation\Http\FormRequest;

class StudentRequest extends FormRequest {
    public function authorize(){ return true; }

    public function rules(){
        $student = $this->route('student');
        $ignoreId = $student ? $student->id : null;
        return [
            'name' => 'required|string|max:255',
            'student_id' => 'required|string|max:50|unique:students,student_id,' . $ignoreId,
            'class' => 'required|string|max:50',
            'section' => 'nullable|string|max:10',
            'photo' => 'nullable|image|max:2048'
        ];
    }
}
