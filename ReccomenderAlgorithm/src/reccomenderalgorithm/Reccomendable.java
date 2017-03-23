/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author u02mfp14
 */
public abstract class Reccomendable {
    public int id;
    private ArrayList<Interest> interests = new ArrayList<Interest>();
    private ArrayList<Interest> importantInterests = new ArrayList<Interest>();
    
    
    public ArrayList<Interest> getInterests() {
        return interests;
    }
    
    public ArrayList<Interest> getImportantInterests() {
        return importantInterests;
    }
    
    public ArrayList<Interest> getAllInterests() {
        ArrayList<Interest> temp = new ArrayList<Interest>(interests);
        temp.addAll(importantInterests);
        return temp;
    }
    
    public void addInterest(Interest i) {
        interests.add(i);
    }
    
    public void setInterests(ArrayList<Interest> i) {
        interests = i;
    }
    
    public void setInterests(ArrayList<Interest> i, ArrayList<Interest> i2) {
        interests = i;
        importantInterests = i2;
    }
    
    public HashMap<String, Integer> numberOfInterestsByCategory() {
        HashMap<String, Integer> result = new HashMap<String, Integer>();
        
        for (Interest i : getAllInterests()) {
            if (result.get(i.group) == null) {
                result.put(i.group, 0);
            }
            int soFar = result.get(i.group);
            result.put(i.group, soFar+1);
        }
        
        return result;
    }
}
