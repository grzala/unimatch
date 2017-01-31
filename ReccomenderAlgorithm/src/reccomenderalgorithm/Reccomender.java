/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author grzala
 */
public class Reccomender {
    
    public static HashMap<Integer, Float> get_matches(int id, Database2 db) {
        return get_matches(id, db, false);
    }
    
    public static HashMap<Integer, Float> get_matches(int id, Database2 db, boolean verbose) {
        HashMap<Integer, Float> result = new HashMap<>();
        
        User usr = db.getUserByID(id);
        if (verbose)
            System.out.println("comparing for " + usr.name);

        for (User usr2 : db.getUsers()) {
            
            //intersections
            ArrayList<Interest> likes1 = new ArrayList<Interest>(usr.interests);
            ArrayList<Interest> likes2 = new ArrayList<Interest>(usr2.interests);
            ArrayList<Interest> dislikes1 = new ArrayList<Interest>(db.interests.values()); dislikes1.removeAll(likes1);
            ArrayList<Interest> dislikes2 = new ArrayList<Interest>(db.interests.values()); dislikes2.removeAll(likes2);

            ArrayList<Interest> likes1likes2intersection = new ArrayList<Interest>(likes1); likes1likes2intersection.retainAll(likes2);
            ArrayList<Interest> dislikes1dislikes2intersection = new ArrayList<Interest>(dislikes1); dislikes1dislikes2intersection.retainAll(dislikes2);
            ArrayList<Interest> likes1dislikes2intersection = new ArrayList<Interest>(likes1); likes1dislikes2intersection.retainAll(dislikes2);
            ArrayList<Interest> dislikes1likes2intersection = new ArrayList<Interest>(dislikes1); dislikes1likes2intersection.retainAll(likes2);

            //union
            Set<Interest> set = new HashSet<Interest>();
            set.addAll(likes1likes2intersection);
            set.addAll(dislikes1dislikes2intersection);
            set.addAll(likes1dislikes2intersection);
            set.addAll(dislikes1likes2intersection);
            ArrayList<Interest> unionAll = new ArrayList<Interest>(set);
            
            //calculate coefficient
            float matchCoefficient;
            matchCoefficient = likes1likes2intersection.size() + dislikes1dislikes2intersection.size();
            matchCoefficient = matchCoefficient - likes1dislikes2intersection.size() - dislikes1likes2intersection.size();
            matchCoefficient /= unionAll.size();
            
            result.put(usr2.id, matchCoefficient);

            if (verbose) {
                System.out.println(usr2.name);
                System.out.println(matchCoefficient);
            }
        }
        
       return result;
    }
    
}
