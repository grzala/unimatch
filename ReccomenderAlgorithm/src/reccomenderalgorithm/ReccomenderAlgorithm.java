/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
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
       FakeDatabase fd = new FakeDatabase();
       
       User usr = fd.users[0];
       System.out.println("comparing for " + usr.name);
       
       for (int i = 1; i < fd.users.length; i++) {
        ArrayList<Interest> likes1 = new ArrayList<Interest>(usr.interests);
        ArrayList<Interest> likes2 = new ArrayList<Interest>(fd.users[i].interests);
        ArrayList<Interest> dislikes1 = new ArrayList<Interest>(Arrays.asList(fd.interests)); dislikes1.removeAll(likes1);
        ArrayList<Interest> dislikes2 = new ArrayList<Interest>(Arrays.asList(fd.interests)); dislikes2.removeAll(likes2);
          
        ArrayList<Interest> likes1likes2intersection = new ArrayList<Interest>(likes1); likes1likes2intersection.retainAll(likes2);
        ArrayList<Interest> dislikes1dislikes2intersection = new ArrayList<Interest>(dislikes1); dislikes1dislikes2intersection.retainAll(dislikes2);
        ArrayList<Interest> likes1dislikes2intersection = new ArrayList<Interest>(likes1); likes1dislikes2intersection.retainAll(dislikes2);
        ArrayList<Interest> dislikes1likes2intersection = new ArrayList<Interest>(dislikes1); dislikes1likes2intersection.retainAll(likes2);
        
        Set<Interest> set = new HashSet<Interest>();
        set.addAll(likes1likes2intersection);
        set.addAll(dislikes1dislikes2intersection);
        set.addAll(likes1dislikes2intersection);
        set.addAll(dislikes1likes2intersection);
        ArrayList<Interest> unionAll = new ArrayList<Interest>(set);
        
        
        System.out.println(fd.users[i].name);
        float matchCoefficient;
        matchCoefficient = likes1likes2intersection.size() + dislikes1dislikes2intersection.size();
        matchCoefficient = matchCoefficient - likes1dislikes2intersection.size() - dislikes1likes2intersection.size();
        matchCoefficient /= unionAll.size();
        System.out.println(matchCoefficient);
               
       }  
    }
}
