package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.Community;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityMapper {

    /**
     * 插入社区
     */
    int insert(Community community);

    /**
     * 根据ID查询社区
     */
    Community selectById(Long id);

    /**
     * 根据名称查询社区
     */
    Community selectByName(String name);

    /**
     * 查询所有公开社区
     */
    List<Community> selectPublicCommunities();

    /**
     * 根据关键词搜索社区
     */
    List<Community> selectByKeyword(@Param("keyword") String keyword);

    /**
     * 查询用户加入的社区
     */
    List<Community> selectByUserId(Long userId);

    /**
     * 更新社区
     */
    int update(Community community);

    /**
     * 删除社区
     */
    int deleteById(Long id);

    /**
     * 增加成员数量
     */
    int incrementMemberCount(Long id);

    /**
     * 减少成员数量
     */
    int decrementMemberCount(Long id);

    /**
     * 获取社区成员数量
     */
    Integer selectMemberCount(Long communityId);

    /**
     * 检查用户是否已加入社区
     */
    boolean existsUserCommunity(@Param("userId") Long userId,
                                @Param("communityId") Long communityId);

    /**
     * 用户加入社区
     */
    int insertUserCommunity(@Param("userId") Long userId,
                            @Param("communityId") Long communityId);

    /**
     * 用户退出社区
     */
    int deleteUserCommunity(@Param("userId") Long userId,
                            @Param("communityId") Long communityId);
}