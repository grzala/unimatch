/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;

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
        
        //similar interests
        ArrayList<Interest> similarInterests = new ArrayList<Interest>(usr.interests);
        similarInterests.retainAll(fd.users[i].interests);
        
        //similar non-interests (raquetball hate)
        ArrayList<Interest> user1Dislikes = new ArrayList<Interest>(Arrays.asList(fd.interests));
        ArrayList<Interest> user2Dislikes = new ArrayList<Interest>(Arrays.asList(fd.interests));
        ArrayList<Interest> dislikes = new ArrayList<Interest>(Arrays.asList(fd.interests));
        user1Dislikes.removeAll(usr.interests);
        user2Dislikes.removeAll(fd.users[i].interests);
        dislikes.removeAll(usr.interests); dislikes.removeAll(fd.users[i].interests);
        
        
        System.out.println(fd.users[i].name);
        float matchCoefficient;
        matchCoefficient = ((float)similarInterests.size() + (float)dislikes.size()) / (float)(usr.interests.size() + fd.users[i].interests.size() + (float)user1Dislikes.size() + (float)user2Dislikes.size());
        System.out.println(matchCoefficient);
        
               
       }
       
    }
    
}
