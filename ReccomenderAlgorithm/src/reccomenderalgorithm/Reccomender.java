/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author grzala
 */
public class Reccomender {
    
    public static final int IMPORTANT_INTERESTS = 5; //how many important interests is there
    public static final int EXPECTED_MAX_MUTUAL_INTERESTS_FRACTION = 4; //how much of all interests are users at most expected to share
    public static final int NORMAL_MUTUAL_INTEREST_SCORE = 10; //this is arbitrary, set to any number you want
    public static final int LIKE_IN_DISLIKED_GROUP_PENALTY = 1; //how much point deducted if i like something somebody doesnt
    public static final int DISLIKE_THRESHOLD = 0; //how little interests do i need to make the category count as disliked?
    
    public static HashMap<Integer, Float> getMatches(Reccomendable rec, ArrayList<Reccomendable> reccomendables, ArrayList<Interest> interests) {
        return getMatches(rec, reccomendables, interests, false);
    }
    
    public static HashMap<Integer, Float> getMatches(Reccomendable rec, ArrayList<Reccomendable> reccomendables, ArrayList<Interest> interests, boolean verbose) {
        HashMap<Integer, Float> result = new HashMap<>();
        
        if (verbose)
            System.out.println("comparing for " + rec.id);
        
        
        int POSSIBLE_INTERESTS = interests.size(); //possble amount of interests to choose from;
        int BIASED_POSSIBLE = POSSIBLE_INTERESTS / EXPECTED_MAX_MUTUAL_INTERESTS_FRACTION;
        int IMPORTANT_MUTUAL_INTEREST_SCORE = ((BIASED_POSSIBLE * NORMAL_MUTUAL_INTEREST_SCORE) / IMPORTANT_INTERESTS) + IMPORTANT_INTERESTS;
        int MAX_SCORE = (IMPORTANT_INTERESTS * NORMAL_MUTUAL_INTEREST_SCORE) + (IMPORTANT_INTERESTS * IMPORTANT_MUTUAL_INTEREST_SCORE);
        
        for (Reccomendable rec2 : reccomendables) {
            ArrayList<Interest> importantInterestsIntersection = new ArrayList<Interest>(rec.getImportantInterests()); 
            importantInterestsIntersection.retainAll(rec2.getImportantInterests());
            
            ArrayList<Interest> allInterestsIntersection = new ArrayList<Interest>(rec.getAllInterests()); 
            allInterestsIntersection.retainAll(rec2.getAllInterests());
            
            int scored = (importantInterestsIntersection.size() * IMPORTANT_MUTUAL_INTEREST_SCORE) + (allInterestsIntersection.size() * NORMAL_MUTUAL_INTEREST_SCORE);
            
            /* CODE BELOW IM NOT SURE OF. MESSES UP RESULTS. IM COMMENTING IT FOR NOW
            HashMap<String, Integer> rec1DislikedCategories = rec.numberOfInterestsByCategory();
            HashMap<String, Integer> rec2DislikedCategories = rec2.numberOfInterestsByCategory();
            ArrayList<String> groups = new ArrayList<String>(rec1DislikedCategories.keySet());
            groups.addAll(new ArrayList<String>(rec2DislikedCategories.keySet()));
            
            
            for (String group : groups) {
                //prevent null pointer exception
                if (rec1DislikedCategories.get(group) == null) rec1DislikedCategories.put(group, 0);
                if (rec2DislikedCategories.get(group) == null) rec2DislikedCategories.put(group, 0);
                
                int likes1 = rec1DislikedCategories.get(group);
                int likes2 = rec1DislikedCategories.get(group);
                //testing this just one way
                
                if (likes1 <= DISLIKE_THRESHOLD && likes2 > DISLIKE_THRESHOLD) { //category disliked by recomebdable 1
                    int diff = likes2 - likes1;
                    //scored -= diff * LIKE_IN_DISLIKED_GROUP_PENALTY;
                }
            }
            */
            
            float percent = (float)scored / (float) MAX_SCORE;
            percent = Math.min(percent, 1.f);
            
            result.put(rec2.id, percent);
            
        }
        
       return result;
    }
    
    private static void printoutInterests(ArrayList<Interest> i) {
        for (Interest i2 : i) {
            System.out.println(i2.name);
        }
    }
    
}

/* OLD MATCHING CODE

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

*/