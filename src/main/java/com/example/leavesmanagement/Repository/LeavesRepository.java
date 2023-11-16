package com.example.leavesmanagement.Repository;

import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.RepositoryMessage;
import lombok.Cleanup;
import org.springframework.stereotype.Repository;

import javax.rmi.PortableRemoteObject;
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

    public void create(Leaves leaves, int user_no) throws Exception {
        String sql = "INSERT INTO leaves VALUES (?, ?, ?, ?, ?, ?);";
        @Cleanup Connection conn = null;
        @Cleanup PreparedStatement pstmt = null;

        conn = dataSource.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, leaves.getStart_date());
        pstmt.setString(2, leaves.getEnd_date());
        pstmt.setString(3, leaves.getType());
        pstmt.setString(4, leaves.getDesc());
        pstmt.setInt(5, leaves.getDates());
        pstmt.setInt(6, user_no);

        pstmt.executeQuery();
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
                    .start_date(rs.getString("start_date"))
                    .end_date(rs.getString("end_date"))
                    .dates(rs.getInt("dates"))
                    .type(rs.getString("type"))
                    .desc(rs.getString("dates"))
                    .build();

            returnValue.add(leaves);
        }
        return returnValue;
    }


}