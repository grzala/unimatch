/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author u01ydd14
 */
public class ReccomenderAlgorithm {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        Server s = new Server();
        try {
            Database d = new DevelopmentDB("../unimatch_rails/db/development.sqlite3");
            s.setDatabase(d);
            s.run();
        } catch(Exception e) {
        }
       
    }
    
}