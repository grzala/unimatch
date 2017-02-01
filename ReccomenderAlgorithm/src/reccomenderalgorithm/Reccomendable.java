/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;

/**
 *
 * @author u02mfp14
 */
public abstract class Reccomendable {
    public int id;
    private ArrayList<Interest> interests = new ArrayList<Interest>();
    
    
    public ArrayList<Interest> getInterests() {
        return interests;
    }
    
    public void addInterest(Interest i) {
        interests.add(i);
    }
    
    public void setInterests(ArrayList<Interest> i) {
        interests = i;
    }
}
