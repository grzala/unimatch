/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

/**
 *
 * @author u01ydd14
 */
public class Interest {
    
    public int id;
    String name, group;
    
    public Interest(int id, String name, String group) {
        this.id = id;
        this.name = name;
        this.group = group;
    }
    
    public boolean equals(Object o) {
        if(!(o instanceof Interest)) {
            return false;
        } else {
            Interest i = (Interest)o;
            return i.id == this.id;
        }
    }
    
}
