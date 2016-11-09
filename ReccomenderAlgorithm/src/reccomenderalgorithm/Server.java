/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.io.BufferedReader;
import java.io.DataOutputStream;
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
    
    private Database db;
    
    public Server() {
         //init db
         System.out.println("initializing database");
         db = new Database();
         System.out.println("database initialized");
    }
    
    public void run() throws Exception {
        ServerSocket serverSocket = null;
        boolean listening = true;

        try {
            serverSocket = new ServerSocket(6789);
        } catch (Exception e) {
            System.err.println("Could not listen on port: 6789.");
            System.exit(-1);
        }

        while (listening)
            new GetReccomendationsThread(serverSocket.accept()).start();

        serverSocket.close();
         
    }
    
    
    private class GetReccomendationsThread extends Thread {
        
        private Socket socket = null;
        public GetReccomendationsThread(Socket socket) {
            super("MultiServerThread");
            this.socket = socket;
        }
        
        public void run() {
            try {
                //get id
                BufferedReader inFromClient =
                   new BufferedReader(new InputStreamReader(socket.getInputStream()));
                
                //get matches, convert to json
                final HashMap<Integer, Float> matches;
                int id = Integer.parseInt(inFromClient.readLine());
                System.out.println("Matching for: " + db.users.get(id).name);
                matches = Reccomender.get_matches(id, db);
                JSONObject jsonMatches = hashMapToJson(matches);
                System.out.println("done matching");
                
                //publish
                final DataOutputStream outputStream = new DataOutputStream(socket.getOutputStream()); // OutputStream where to send the map in case of network you get it from the Socket instance.
                outputStream.writeBytes(jsonMatches.toString()+"\n");
            } catch(Exception e) {
                
            }
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
