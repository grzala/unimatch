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
    
    public static HashMap<Integer, Float> getMatches(Reccomendable rec, ArrayList<Reccomendable> reccomendables, ArrayList<Interest> interests) {
        return getMatches(rec, reccomendables, interests, false);
    }
    
    public static HashMap<Integer, Float> getMatches(Reccomendable rec, ArrayList<Reccomendable> reccomendables, ArrayList<Interest> interests, boolean verbose) {
        HashMap<Integer, Float> result = new HashMap<>();
        
        if (verbose)
            System.out.println("comparing for " + rec.id);

        for (Reccomendable rec2 : reccomendables) {
            
            //intersections
            ArrayList<Interest> likes1 = new ArrayList<Interest>(rec.getInterests());
            ArrayList<Interest> likes2 = new ArrayList<Interest>(rec2.getInterests());
            ArrayList<Interest> dislikes1 = new ArrayList<Interest>(interests); dislikes1.removeAll(likes1);
            ArrayList<Interest> dislikes2 = new ArrayList<Interest>(interests); dislikes2.removeAll(likes2);

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
            
            result.put(rec2.id, matchCoefficient);
            
            
        }
        
       return result;
    }
    
    private static void printoutInterests(ArrayList<Interest> i) {
        for (Interest i2 : i) {
            System.out.println(i2.name);
        }
    }
    
}
