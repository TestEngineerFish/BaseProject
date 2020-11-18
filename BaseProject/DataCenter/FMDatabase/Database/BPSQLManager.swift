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
    static let createIMTables = [
        CreateIMTableSQLs.session.rawValue,
        CreateIMTableSQLs.message.rawValue,
        CreateIMTableSQLs.friend.rawValue]

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
        case session =
        """
        CREATE TABLE IF NOT EXISTS bp_session(
            serial integer primary key,
            session_id text,
            session_type integer default 0,
            is_top integer default 0,
            friend_id text,
            friend_name text,
            friend_avatar_url text,
            last_msg text,
            msg_time integer,
            msg_status integer,
            msg_unread_count integer default 0,
            last_show_time integer,
            draft_content text,
            draft_time integer,
            create_time integer(32) NOT NULL DEFAULT(datetime('now', 'localtime')),
            local_extend blob,
            remote_extend blob);
        """
        case message =
        """
        CREATE TABLE IF NOT EXISTS bp_message(
            serial integer primary key,
            msg_id text,
            session_id text,
            type integer,
            status integer,
            content text,
            from_type integer,
            media_json text,
            create_time integer(32) NOT NULL DEFAULT(datetime('now', 'localtime')),
            is_unread integer,
            local_extend blob,
            remote_extend blob
        );
        """
        case friend =
        """
        CREATE TABLE IF NOT EXISTS bp_friend(
            serial integer primary key,
            friend_id integer,
            name text,
            friend_avatar_url text,
            status integer,
            create_time integer(32) NOT NULL DEFAULT(datetime('now', 'localtime')),
            local_extend blob,
            remote_extend blob);
        """
    }

    // MARK: IM表
    // TODO: ==== Session ====
    enum IMSession: String {
        case selectAllSession =
        """
        SELECT * FROM bp_session
        """
        case selectSession =
        """
        SELECT * FROM bp_session
        WHERE friend_id = ?
        """
        case insertSession =
        """
        INSERT INTO bp_session(
            session_id,
            session_type,
            friend_id,
            friend_name,
            friend_avatar_url,
            last_msg,
            msg_time,
            msg_status)
        VALUES (?,?,?,?,?,
                ?,?,?);
        """
        case updateSession =
        """
        UPDATE bp_session
        SET last_msg = ?, msg_time = ?, msg_status = ?, msg_unread_count = ?, draft_content = NULL, draft_time = NULL
        WHERE session_id = ?
        """
        case updateSessionLastShowTime =
        """
        UPDATE bp_session
        SET last_show_time = ?
        WHERE session_id = ?
        """
        case updateSessionDraft =
        """
        UPDATE bp_session
        SET draft_content = ?, draft_time = ?
        WHERE session_id = ?
        """
        case deleteSession =
        """
        DELETE FROM bp_session
        WHERE session_id = ?
        """
        case deleteAllSession =
        """
        DELETE FROM bp_session
        """
    }

    // TODO: ==== Message ====
    enum IMMessage: String {
        case selectAllMessage =
        """
        SELECT * FROM bp_message
        WHERE session_id = ?
        """
        case insertMessage =
        """
        INSERT INTO bp_message(
            msg_id,
            session_id,
            type,
            from_type,
            status,
            content,
            media_json,
            create_time,
            is_unread)
        VALUES (?,?,?,?,?,
                ?,?,?,?)
        """
        case deleteAllMessageWithSession =
        """
        DELETE FROM bp_message
        WHERE session_id = ?
        """
    }

    
}
