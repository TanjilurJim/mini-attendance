<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreBulkAttendanceRequest extends FormRequest
{
    public function authorize()
    {
        return auth()->check();
    }

    public function rules()
    {
        return [
            'records' => 'required|array|min:1',
            'records.*.student_id' => 'required|exists:students,id',
            'records.*.date' => 'required|date',
            'records.*.status' => 'required|in:present,absent,late',
            'records.*.note' => 'nullable|string',
        ];
    }
}
