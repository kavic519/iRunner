package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.Coordinate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CoordinateMapper {

    /**
     * 插入单个坐标点
     */
    int insert(Coordinate coordinate);

    /**
     * 批量插入坐标点
     */
    int insertBatch(@Param("list") List<Coordinate> coordinates);

    /**
     * 根据跑步记录ID查询坐标点
     */
    List<Coordinate> selectByRunSessionId(Long runSessionId);

    /**
     * 根据跑步记录ID删除坐标点
     */
    int deleteByRunSessionId(Long runSessionId);

    /**
     * 根据ID删除坐标点
     */
    int deleteById(Long id);

    /**
     * 更新坐标点
     */
    int update(Coordinate coordinate);
}