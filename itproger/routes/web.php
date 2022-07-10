<?php

use App\Http\Controllers\ContactController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('home');
});

Route::get('/about', function(){
    return view('about');
});

Route::get('/contacts', function(){
    return view('constacts');
});

Route::post('/contacts/submit', [ContactController::class, 'submit'])->name('contact-form');
Route::get('/contacts/submit/allData', [ContactController::class, 'allData'])->name('contact-form');
Route::get('/contacts/submit/allData/{id}', [ContactController::class, 'byId'])->name('contact-form');
Route::delete('/contacts/submit/delete/{id}', [ContactController::class, 'deleting']);
Route::put('/contacts/update/{id}', [ContactController::class, 'update']);

