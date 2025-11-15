<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StudentRequest;
use App\Http\Resources\StudentResource;
use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class StudentController extends Controller
{
    public function index(Request $req)
    {
        $q = Student::query();
        if ($req->filled('class')) $q->where('class', $req->class);
        if ($req->filled('search')) $q->where('name', 'like', '%' . $req->search . '%');
        $students = $q->orderBy('name')->paginate(12);
        return StudentResource::collection($students);
    }

    public function store(StudentRequest $req)
    {
        $data = $req->validated();
        if ($req->hasFile('photo')) {
            $path = $req->file('photo')->store('students', 'public');
            $data['photo'] = $path;
        }
        $student = Student::create($data);
        return (new StudentResource($student))->response()->setStatusCode(201);
    }

    public function show(Student $student)
    {
        return new StudentResource($student);
    }

    public function update(StudentRequest $req, Student $student)
    {
        $data = $req->validated();
        if ($req->hasFile('photo')) {
            if ($student->photo) Storage::disk('public')->delete($student->photo);
            $data['photo'] = $req->file('photo')->store('students', 'public');
        }
        $student->update($data);
        return new StudentResource($student);
    }

    public function destroy(Student $student)
    {
        if ($student->photo) Storage::disk('public')->delete($student->photo);
        $student->delete();
        return response()->noContent();
    }
}
