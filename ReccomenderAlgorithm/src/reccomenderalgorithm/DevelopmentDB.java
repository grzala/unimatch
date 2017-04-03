/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reccomenderalgorithm;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;


/**
 *
 * @author grzala
 */
public class DevelopmentDB implements Database{
        
    String filePath;
    
    //interests and groups are fixed, restart algorithm server if changes are made
    public HashMap<Integer, String> interest_groups = new HashMap<>();
    public HashMap<Integer, Interest> interests = new HashMap<>();
    
    //statements
    Connection con = null;
    final String getUsersSTMT = "SELECT * FROM users;";
    final String getSocietiesSTMT = "SELECT * FROM societies;";
    final String getUserByIDSTMT = "SELECT * FROM users WHERE id = ?";
    final String getSocietyByIDSTMT = "SELECT * FROM societies WHERE id = ?";
    final String getUserInterestsSTMT = "SELECT * FROM user_interests WHERE user_id = ? AND important = ? ;";
    final String getSocietyInterestsSTMT = "SELECT * FROM society_interests WHERE society_id = ? ;";
    final String getInterestGroupsSTMT = "SELECT * FROM interest_groups";
    final String getInterestsSTMT = "SELECT * FROM interests";
    final String removeReccomendationsSTMT = "DELETE FROM reccomendations WHERE user_id = ? and match_id = ? and match_type = ?";
    final String reccomendSTMT = "INSERT INTO reccomendations (\"user_id\", \"match_type\", \"match_id\", \"coefficient\", \"created_at\", \"updated_at\") VALUES (?, ?, ?, ?, ?, ?)";
    
    public DevelopmentDB(String filePath) {
        this.filePath = filePath;
        connect();
        
        populateTables();
    }
    
    public void connect() {
        try {
            if (con != null && !con.isClosed()) return;
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:" + filePath);
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            System.exit(0);
        }
        //System.out.println("Opened database successfully");
    }
    
    //gets user By ID alongside with his interests
    public User getUserByID(int id) { 
        User usr = null;
        try {
            PreparedStatement getUser = con.prepareStatement(getUserByIDSTMT);
            getUser.setInt(1, id);
            ResultSet rs = getUser.executeQuery();
            
            String name = rs.getString("name");
            String surname = rs.getString("surname");
            usr = new User(id, name, surname);
            usr.setInterests(getUserInterests(usr.id, false), getUserInterests(usr.id, true));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usr;
    }
    
    public ArrayList<User> getUsers() {
        ArrayList<User> result = new ArrayList<User>();
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(getUsersSTMT);
            
            while (rs.next()) {
                int id = rs.getInt("id");
                result.add(getUserByID(id));
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public ArrayList<Interest> getUserInterests(int id, boolean important) {
        ArrayList<Interest> result = new ArrayList<Interest>();
        try {
            PreparedStatement getUserInterest = con.prepareStatement(getUserInterestsSTMT);
            getUserInterest.setInt(1, id);
            String b = important ? "t" : "f";
            getUserInterest.setString(2, b);
            ResultSet rs = getUserInterest.executeQuery();
            
            while (rs.next()) {
                int interest_id = rs.getInt("interest_id");
                result.add(findInterestByID(interest_id));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public Society getSocietyByID(int id) { 
        Society soc = null;
        try {
            PreparedStatement getUser = con.prepareStatement(getSocietyByIDSTMT);
            getUser.setInt(1, id);
            ResultSet rs = getUser.executeQuery();
            
            String name = rs.getString("name");
            soc = new Society(id, name);
            //all society interests are important
            soc.setInterests(new ArrayList<Interest>(), getSocietyInterests(soc.id));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return soc;
    }
    
    public ArrayList<Society> getSocieties() {
        ArrayList<Society> result = new ArrayList<Society>();
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(getSocietiesSTMT);
            
            while (rs.next()) {
                int id = rs.getInt("id");
                result.add(getSocietyByID(id));
            }
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public ArrayList<Interest> getSocietyInterests(int id) {
        ArrayList<Interest> result = new ArrayList<Interest>();
        try {
            PreparedStatement getSocInterest = con.prepareStatement(getSocietyInterestsSTMT);
            getSocInterest.setInt(1, id);
            ResultSet rs = getSocInterest.executeQuery();
            
            while (rs.next()) {
                int interest_id = rs.getInt("interest_id");
                result.add(findInterestByID(interest_id));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public ArrayList<Interest> getInterests() {
        return new ArrayList<Interest>(interests.values());
    }
    
    public Interest findInterestByID(int id) {
        return interests.get(id);
    }
    
    private void populateTables() {
        try {
            Statement stmt = con.createStatement();
            ResultSet rs; 
            //interest groups
            rs = stmt.executeQuery(getInterestGroupsSTMT);

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                interest_groups.put(id, name);
            }
            
            //interests 
            rs = stmt.executeQuery(getInterestsSTMT);

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                Interest interest = new Interest(id, name, interest_groups.get(rs.getInt("interest_group_id")));
                interests.put(id, interest);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void saveMatches(int id, HashMap<Integer, Float> matches, String type) {
        try {
            
            for (Integer match_id : matches.keySet()) {
                //remove existing match
                PreparedStatement remove = con.prepareStatement(removeReccomendationsSTMT);
                remove.setInt(1, id);
                remove.setInt(2, match_id);
                remove.setString(3, type);
                remove.execute();
                
                //save Match
                java.util.Date date = Calendar.getInstance().getTime();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS000");
                PreparedStatement insert = con.prepareStatement(reccomendSTMT);
                insert.setInt(1, id);
                insert.setString(2, type);
                insert.setInt(3, match_id);
                insert.setFloat(4, matches.get(match_id));
                insert.setString(5, sdf.format(date));
                insert.setString(6, sdf.format(date));
                insert.execute();
            }
            
            
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void close() {
        try {
            if (con != null) {
                con.close();
                con = null;
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean isClosed() {
        try {
            return con == null || con.isClosed();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    } 
}
