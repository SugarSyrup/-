package com.example.leavesmanagement.Repository;

import com.example.leavesmanagement.entity.Leaves;
import lombok.Cleanup;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SwiftCodeRepository {
    private final DataSource dataSource;
    public SwiftCodeRepository(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<String> getDepartments() throws Exception{
        String sql = "select name from swiftcode where CodeTypeId = 'DEP' ORDER BY SwiftCodeId";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        List<String> returnValue = new ArrayList<String>();
        while(rs.next()) {
            returnValue.add(rs.getString("name"));
        }
        return returnValue;
    }

    public String getColor(String department) throws Exception{
        String sql = "SELECT getColor(?) as name;";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, department);
        rs = pstmt.executeQuery();

        rs.next();

        return rs.getString("name");
    }


    public List<String> getLeavesType() throws Exception {
        String sql = "select name from swiftcode where CodeTypeId = 'LTY' ORDER BY SwiftCodeId";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        List<String> returnValue = new ArrayList<String>();
        while(rs.next()) {
            returnValue.add(rs.getString("name"));
        }
        return returnValue;
    }
}
