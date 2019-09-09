//
//  BPSQLManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

struct BPSQLManager {

    /// 初始化普通数据时,构造的表结构
    static let createNormalTables = [CreateNormalTableSQLs.newsNotification.rawValue]

    /// 初始化IM系统数据时,构造的表结构
    static let createIMTables = [CreateIMTableSQLs.recentSession.rawValue,
                                CreateIMTableSQLs.recentSessionMap.rawValue]

    // MARK: 创建表
    /// 创建普通数据的所需要的表结构
    enum CreateNormalTableSQLs: String {
        case newsNotification =
        """
        create table if not exists bp_news_notification(serial integer primary key, title text, content_url text, sender_name text, time integer)
        """
    }
    /// 创建IM系统所需要的表结构
    enum CreateIMTableSQLs: String {
        case recentSession =
        """
        create table if not exists bp_recent_session(serial integer primary key, session_id text, session_type integer default 0, msg_id text, msg_from_user_id text, msg_from_user_name text, msg_from_user_avatar_url text, msg_content text, msg_type integer, msg_time integer, msg_status integer, msg_unread_count integer default 0, local_extend blob, remote_extend blob)
        """
        case message =
        """
        create table if not exists bp_message(serial integer primary key, msg_id integer, type integer, from_user_id text, to_user_id text, status integer, content text, time integer, unread integer, local_extend blob, remote_extend blob)
        """
        case recentSessionMap =
        """
        create table if not exists bp_recent_session_map(serial integer primary key, session_id integer, message_table_name text)
        """
    }

    // MARK: 修改表


    // MARK: 查询表
    enum SelectIMTableSQLs: String {
        case selectAllRecentSession =
        """
        select * from bp_recent_session
        """
    }

    
}
