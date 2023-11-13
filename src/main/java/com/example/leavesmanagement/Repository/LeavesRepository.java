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
public class LeavesRepository {
    private final DataSource dataSource;
    public LeavesRepository(DataSource dataSource) {
        this.dataSource = dataSource;
    }


    public List<Leaves> getLeaves() throws Exception{
        String sql = "select * from leaves";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;
        ResultSet rs = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        List<Leaves> returnValue = new ArrayList<Leaves>();
        while(rs.next()) {
            Leaves leaves = Leaves.builder()
                    .user_no(rs.getInt("user_no"))
                    .start_date(rs.getDate("start_date"))
                    .end_date(rs.getDate("end_date"))
                    .dates(rs.getInt("dates"))
                    .type(rs.getString("type"))
                    .desc(rs.getString("dates"))
                    .build();

            returnValue.add(leaves);
        }
        return returnValue;
    }

}