/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import org.json.JSONException;

import org.json.JSONObject;

/**
 *
 * @author grzala
 */
public class Server {
    
    public static Database db;
    public static int dbSemaphore = 0;
    final private int port;
    
    public Server(int port) {
         //init db
         db = null;
         
         this.port = port;
    }
    
    public void setDatabase(Database db) {
        this.db = db;
    }
    
    public void run() throws Exception {
        if (db == null) throw new Exception();
        
        ServerSocket serverSocket = null;
        boolean listening = true;

        try {
            serverSocket = new ServerSocket(port);
        } catch (Exception e) {
            System.err.println("Could not listen on port: 6789.");
            System.exit(-1);
        }
        
        //if no threads are running, close the connection
        new Thread(new Runnable() {
            public void run() {
                while (true) {
                    if (dbSemaphore <= 0)
                        db.close();
                    try {
                        Thread.sleep(5000); //no need to keep this thread running as fast as possible
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } 
            }
        }).start();
        
        try {
            while (listening) {
                new GetReccomendationsThread(serverSocket.accept()).start();
            }
        } catch (Exception e) {} 
         
    }
    
    
    private class GetReccomendationsThread extends Thread {
        
        private Socket socket = null;
        public GetReccomendationsThread(Socket socket) {
            super("MultiServerThread");
            this.socket = socket;
        }
        
        public void run() {
            db.connect();
            dbSemaphore++;
            try {
                //get id
                BufferedReader inFromClient =
                   new BufferedReader(new InputStreamReader(socket.getInputStream()));
                
                String message = inFromClient.readLine();
                int id = Integer.parseInt(message);
                String toSend = getMatches(id);
                
                final DataOutputStream outputStream = new DataOutputStream(socket.getOutputStream()); // OutputStream where to send the map in case of network you get it from the Socket instance.
                outputStream.writeBytes(toSend+"\n");
            } catch(Exception e) {
                
            }
            dbSemaphore--;
        }
        
        private String getMatches(int id) throws JSONException, IOException {
            //get matches, convert to json
            final HashMap<Integer, Float> matches;
            System.out.println("Matching for: " + db.getUserByID(id).name);
            matches = Reccomender.get_matches(db.getUserByID(id), db.getUsers(), db.getInterests(), false);
            JSONObject jsonMatches = hashMapToJson(matches);
            System.out.println("done matching");
            return jsonMatches.toString();
        }
        
        private JSONObject hashMapToJson(HashMap<Integer, Float> map) {
            String tojson = "{";
            for (Integer key : map.keySet()) {
                String id = Integer.toString(key);
                String match = Float.toString(map.get(key));
                tojson += " \""+id+"\":"+" \""+match+"\",";
            }
            tojson += "}";
            
            JSONObject json;
            try {
                json = new JSONObject(tojson);
            } catch(JSONException e) {
                return new JSONObject();
            }
            
            return json;
        }
    }
}
