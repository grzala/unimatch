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
        //Database db = new Database();

        //HashMap<Integer, Float> matches = new HashMap<>();
        //matches = Reccomender.get_matches(10, db);

        //System.out.println(matches.size());

        try {
            Server.run();
        } catch(Exception e) {
            
        }
       
    }
    
    
}