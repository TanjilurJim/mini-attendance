<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StudentRequest;
use App\Http\Resources\StudentResource;
use App\Models\Student;
use Illuminate\Http\Request;

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
            $filename = time() . '_' . $req->photo->getClientOriginalName();
            $req->photo->move(public_path('students'), $filename);
            $data['photo'] = $filename;
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

            // Delete old image
            if ($student->photo) {
                $oldPath = public_path('students/' . $student->photo);
                if (file_exists($oldPath)) unlink($oldPath);
            }

            // Save new image
            $filename = time() . '_' . $req->photo->getClientOriginalName();
            $req->photo->move(public_path('students'), $filename);
            $data['photo'] = $filename;
        }

        $student->update($data);

        return new StudentResource($student);
    }

    public function destroy(Student $student)
    {
        if ($student->photo) {
            $path = public_path('students/' . $student->photo);
            if (file_exists($path)) unlink($path);
        }

        $student->delete();

        return response()->noContent();
    }
}
