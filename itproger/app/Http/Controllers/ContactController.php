<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ContactController extends Controller
{
    public function submit(Request $request)
    {
        
        $user = Contact::create([
            'name' => $request['name'],
            'email' => $request['name'],
            'subject' => $request['subject'],
            'message' => $request['message'],
        ]);


        //  DB::table('contacts')->insert([
        //     'name' => $user['name'],
        //     'email' => $user['name'],
        //     'subject' => $user['subject'],
        //     'message' => $user['message'],
        // ]);

        return response([
            'user' => $user,
            // 'token' => $user->createToken('secret')->plainTextToken()
            ]);
    }

    public function allData()
    {;
        return ['contacts' => DB::table('contacts')->get()];
    }

    public function byId($id)
    {
        $check = DB::table('contacts')->find($id);
        if(!$check)
        {
            return response([
                'message' => 'error'
            ]);
        }
        return ['contacts' => DB::table('contacts')->where('id', '=' , $id)->get()];
    }


    public function deleting($id)
    {
        
        DB::table("contacts")->where('id', '=', $id)->delete();
    }

    public function update(Request $request,$id)
    {
        DB::table('contacts')->where('id' , '=' , $id)->update(['name' => $request['name']]);
    }
}
