package it.betacom.main;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
      
        String url = "jdbc:mysql://localhost:3306/db_libri";
        String username = "";
        String password = "";

        try {
            Connection connection = DriverManager.getConnection(url, username, password);

            CallableStatement statement = connection.prepareCall("{ CALL get_age_autori_nazione(?) }");
            statement.setString(1, "ITA");
            ResultSet resultSet = statement.executeQuery();

            List<String> autoriEtaList = new ArrayList<>();
            while (resultSet.next()) {
                String nome = resultSet.getString("nome");
                String cognome = resultSet.getString("cognome");
                int eta = resultSet.getInt("eta");

                String autoreEta = nome + " " + cognome + ": " + eta + " anni";
                autoriEtaList.add(autoreEta);
            }

            for (String autoreEta : autoriEtaList) {
                System.out.println(autoreEta);
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
