import { createClient } from 'npm:@supabase/supabase-js@2';
import { JWT } from 'npm:google-auth-library@9';

interface notify {
  prn: string;
  subject_code: string;
  date: Date;
  attendance_status: boolean;
}

interface webhookPayload {
  type: 'INSERT';
  table: string;
  record: notify;
  schema: 'public';
  old_record: null | notify;
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

Deno.serve(async (req) => {
  const payload: webhookPayload = await req.json();
  
  // Fetch the FCM token from the 'firebase_token' table
  const { data: tokenData } = await supabase
    .from('firebase_token')
    .select('token')
    .eq('prn', payload.record.prn)
    .single();

  const fcmtoken = tokenData!.token as string;

  // Fetch the subject name from the 'subject_details' table using subject_code
  const { data: subjectData } = await supabase
    .from('subject_detail')
    .select('subject_name')
    .eq('subject_code', payload.record.subject_code)
    .single();

  const subjectName = subjectData!.subject_name;

  const { default: serviceAccount } = await import('../service-account.json', {
    with: { type: 'json' },
  });

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  });

  // Create message based on attendance_status and subject name
  const messageTitle = 'Attendance confirmation';
  const formattedDate = new Date(payload.record.date).toLocaleDateString(); // Format the date for message
  const messageBody =
  payload.record.attendance_status
          ? `You were marked present for ${subjectName} on ${formattedDate}.`
           : `You were marked absent for ${subjectName} on ${formattedDate}.`;

  // Send notification via Firebase Cloud Messaging (FCM)
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: fcmtoken,
          notification: {
            title: messageTitle,
            body: messageBody,
          },
        },
      }),
    },
  );

  const resData = await res.json();
  if (res.status < 200 || res.status > 299) {
    throw resData;
  }

  await supabase
    .from('notification_table')
    .insert(
      {
        prn: payload.record.prn,
        notification_detail: messageBody,
        notification_read: false, 
      },
    );

  return new Response(
    JSON.stringify(resData),
    { headers: { 'Content-Type': 'application/json' } },
  );
});

// Function to get Firebase access token for FCM
const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};


// import { createClient } from 'npm:@supabase/supabase-js@2';
// import { JWT } from 'npm:google-auth-library@9';

// interface notify {
//   prn: string;
//   subject_code: string;
//   date: Date;
//   attendance_status: boolean;
// }

// interface webhookPayload {
//   type: 'INSERT';
//   table: string;
//   record: notify;
//   schema: 'public';
//   old_record: null | notify;
// }

// const supabase = createClient(
//   Deno.env.get('SUPABASE_URL')!,
//   Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
// );

// Deno.serve(async (req) => {
//   const payload: webhookPayload = await req.json();
  
//   // Fetch the FCM token from the 'firebase_token' table
//   const { data: tokenData } = await supabase
//     .from('firebase_token')
//     .select('token')
//     .eq('prn', payload.record.prn)
//     .single();

//   const fcmtoken = tokenData!.token as string;

//   // Fetch the subject name from the 'subject_details' table using subject_code
//   const { data: subjectData } = await supabase
//     .from('subject_detail')
//     .select('subject_name')
//     .eq('subject_code', payload.record.subject_code)
//     .single();

//   const subjectName = subjectData!.subject_name;

//   const { default: serviceAccount } = await import('../service-account.json', {
//     with: { type: 'json' },
//   });

//   const accessToken = await getAccessToken({
//     clientEmail: serviceAccount.client_email,
//     privateKey: serviceAccount.private_key,
//   });

//   // Create message based on attendance_status and subject name
//   const messageTitle = 'Attendance confirmation';
//   const formattedDate = new Date(payload.record.date).toLocaleDateString(); // Format the date for message
//   const messageBody =
//     payload.record.attendance_status
//       ? `You were marked present for ${subjectName} on ${formattedDate}.`
//       : `You were marked absent for ${subjectName} on ${formattedDate}.`;

//   // Send notification via Firebase Cloud Messaging (FCM)
//   const res = await fetch(
//    `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
//     {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         Authorization: `Bearer ${accessToken}`,
//       },
//       body: JSON.stringify({
//         message: {
//           token: fcmtoken,
//           notification: {
//             title: messageTitle,
//             body: messageBody,
//           },
//         },
//       }),
//     },
//   );

//   const resData = await res.json();
//   if (res.status < 200 || res.status > 299) {
//     throw resData;
//   }

//   return new Response(
//     JSON.stringify(resData),
//     { headers: { 'Content-Type': 'application/json' } },
//   );
// });

// // Function to get Firebase access token for FCM
// const getAccessToken = ({
//   clientEmail,
//   privateKey,
// }: {
//   clientEmail: string;
//   privateKey: string;
// }): Promise<string> => {
//   return new Promise((resolve, reject) => {
//     const jwtClient = new JWT({
//       email: clientEmail,
//       key: privateKey,
//       scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
//     });
//     jwtClient.authorize((err, tokens) => {
//       if (err) {
//         reject(err);
//         return;
//       }
//       resolve(tokens!.access_token!);
//     });
//   });
// };
