
import {createClient} from 'npm:@supabase/supabase-js@2'
import{JWT} from 'npm:google-auth-library@9'

interface notify{
  prn: string
  subject_code: string
  date: Date
  attendance_status: boolean
}


interface webhookPayload{
  type :'INSERT'
  table : string
  record : notify
  schema: 'public',
  old_record: null | notify
}
 
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {


  const payload: webhookPayload = await req.json();
    const {data} = await supabase.from('firebase_token')
    .select('token')
    .eq('prn', payload.record.prn)
    .single()
  
const fcmtoken = data!.token as string
const {default: serviceAccount} = await import('../service-account.json',{
  with: {type: 'json'}
})

const accessToken = await getAccessToken({clientEmail: serviceAccount.client_email,privateKey: serviceAccount.private_key,})


const res = await fetch(
  `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
  {
    method: 'POST',
    headers:{
      'Content-Type':'application/json',
      Authorization: `Bearer ${accessToken}`,
    },
    body: JSON.stringify({
      message:{
        token : fcmtoken,
        notification:{
          title : `Attendance confirmation`,
          body: `Your are marked present for .00`
        },
      },
    }),
  }
)



  const resData = await res.json();
  if(res.status <200 || 299 < res.status){
    throw resData 
    
  }



  return new Response(
    JSON.stringify(resData),
    { headers: { "Content-Type": "application/json" } },
  )
});



const getAccessToken = ({
  clientEmail,
  privateKey
}:{
  clientEmail: string
  privateKey: string
}): Promise<string> =>{
  return new Promise((resolve ,reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    jwtClient.authorize((err,tokens)=>{
      if(err){
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};


