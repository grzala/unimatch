/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.io.FileInputStream;
import java.util.Properties;

/**
 *
 * @author u01ydd14
 */
public class ReccomenderAlgorithm {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        //Production DB
        //Database d = new ProductionDB("127.0.0.1", "alg", "alg");
        
        int port = 6789;
        String filePath = "";
        Database d = null;
        //read properties
        try {
            Properties props = new Properties();
            FileInputStream in = new FileInputStream("config.properties");
            props.load(in);
            
            port = Integer.parseInt((String)props.get("SERVER_PORT"));
            filePath = (String)props.get("SQLITE_PATH");
            
            if (props.get("ENV").equals("local")) {
                d = new DevelopmentDB(filePath);
            } else if (props.get("ENV").equals("production")) {
                String dbHostname = (String)props.get("HOSTNAME");
                String dbUser = (String)props.get("USER");
                String dbPassword = (String)props.get("PASSWORD");
                
                d = new ProductionDB(dbHostname, dbUser, dbPassword);
            }
            
            in.close();
        } catch(Exception e) {
            e.printStackTrace();            
        }
        
        Server s = new Server(port);
        try {
            s.setDatabase(d);
            s.run();
        } catch(Exception e) {
        }
       
    }
    
}