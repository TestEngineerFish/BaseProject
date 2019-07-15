//
//  IconFontString.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
public enum Iconfont: String {
    
    // MARK: --- common ---
    
    case microphone = "\u{e63c}"    // 小话筒
    case revoke = "\u{e67c}"        // 撤回、撤销
    case closeInvite = "\u{e66a}"
    case weixinInvite = "\u{e61f}"
    case qqInvite = "\u{e64a}"
    case contactsInvite = "\u{e649}"
    case bugle = "\u{e666}"                 // 小喇叭
    case camera = "\u{e668}"
    case smileFace = "\u{e656}"
    case male = "\u{e673}"
    case female = "\u{e672}"
    case invisible = "\u{e689}"     // 隐藏状态下的眼睛图标
    case viseible = "\u{e68a}"
    
    case praise = "\u{e671}"        // 点赞
    case stick = "\u{e69b}"         // 置顶
    case hide = "\u{e695}"          // 隐藏
    case like = "\u{e638}"
    
    case timelineIcon = "\u{e65d}"
    case qqZoneIcon = "\u{e65e}"
    case copyIcon = "\u{e662}"
    case qrCodeIcon = "\u{e640}"
    case scanIcon = "\u{e65c}"
    case openPhoto = "\u{e698}"
    case wordIcon = "\u{e699}"
    
    case backBarItem = "\u{e637}"
    case questionIcon = "\u{e677}"
    case questionIcon2 = "\u{e685}"
    
    case location = "\u{e694}"
    
    // MARK: --- youyou ---
    
    // MARK: --- message ---
    
    // MARK: --- homepage ---
    case indicatorAccessoryRight = "\u{e6cc}"   // 右箭头：>
    case multiEdit = "\u{e69c}"             // 编辑
    case addSymbol = "\u{e664}"             // 添加符号"+"
    case fingerPrint = "\u{e67d}"           // 指纹
    case setting = "\u{e66e}"               // 设置
    case checkmark = "\u{e633}"             // 检查 √
    case usermen = "\u{e659}"
    case cancel = "\u{e632}"                // 圆角取消
    case edit = "\u{e635}"                  // 笔状编辑
    case chat = "\u{e64e}"                  // 交谈
    case sms = "\u{e646}"                   // sms 发消息
    case submit = "\u{e68f}"                // 写介绍提交
    case pen = "\u{e693}"                   // 写介绍 笔
    case coin = "\u{e69d}"                  // 友币图标
    case search = "\u{e663}"                // 搜索
    case recurring = "\u{e692}"             // 重置
    case video = "\u{e67a}"                 // 录像
    case picture = "\u{e636}"               // 图片
    
    case stop = "\u{e696}"
    case up = "\u{e66f}"        //置顶
    case down = "\u{e660}"
    case user_shield = "\u{e66d}"
    case appointment = "\u{e631}"
    case noData = "\u{e676}"
    
    case notification = "\u{e69a}"
    
    // MARK: - Record Video
    case selectVideo = "\u{e67e}"
    case swithGroup = "\u{e6b3}"
    case swithList = "\u{e6b2}"
    case filter = "\u{e6b0}"
    
    
    /**
     * Version: 1.2.0
     * 暂时先保留1.2.0版本之前IconFont预置,避免编译出错
     */
    
    // 登录注册
    case bingo = "\u{eac9}" // 口令识别成功
    
    //
    //    case bookIcon = "\u{e71d}" // 通讯录
    
    //
    case more = "\u{e824}"
    case pause = "\u{e98d}"
    case play = "\u{e978}"
    case dynamic_search = "\u{e893}"
    case session_up = "\u{e6d6}"
    case session_down = "\u{e6d5}"
    case cancel_shield = "\u{ea51}"     ///取消屏蔽
    case shield = "\u{e941}"            ///屏蔽
    case arrow_down = "\u{e6ca}"
    case arrow_up = "\u{e6cd}"
    case apps = "\u{e6d4}"
    
    // 公共部分
    case send = "\u{e93e}"
    case back = "\u{e6c9}" // 返回
    case close = "\u{ea60}"
    case delete = "\u{ea5d}"
    case report = "\u{eaaf}" //举报
    case ellipais_v = "\u{e82b}"
    
    // 视频部分
    case switchCamera = "\u{e749}" // 切换前后摄像头
    case selectSticker = "\u{eac0}" // 选择贴纸
    case selectFilter = "\u{eac1}" // 选择滤镜
    case addSubtitle = "\u{ea49}" // 添加文字
    case selectMusic = "\u{e965}" // 选择音乐
    case playMusic = "\u{e964}" // 音乐播放中
    case downloadResource = "\u{e77e}" // 下载素材
    case centerAliment = "\u{e6b6}" // 文字居中
    case leftAliment = "\u{e6ba}" // 文字居左
    case rightAliment = "\u{e6bd}" // 文字居右
    case selectTextColor = "\u{eabf}" // 选择文字颜色
    case selectTextBackgroundColor = "\u{eac3}" // 选择文字背景颜色
    case applyEditVideo = "\u{e767}" // 应用视频编辑
    case scaleAndRotate = "\u{e6eb}" // 缩放旋转按钮
    case hashTag = "\u{eac6}" // 选择标签空白显示符
    case editTagPen = "\u{e985}" // 修改新建标签
    
    // 个人主页部分
    case hp_setting = "\u{e7aa}"   // 设置
    case hp_qrCode = "\u{eac2}"   // 二维码
    
    case hp_like = "\u{e8c4}"   // 点赞
    case hp_like_selected = "\u{eabe}"
    case hp_write = "\u{e825}"  // 写介绍
    
    //case hp_f_shield = "\u{e85e}" // 屏蔽 眼睛形状(好友列，头像下的屏蔽状态)
    //case hp_f_watch = "\u{e85d}" // 查看 眼睛形状
    
    case hp_shield_person = "\u{eace}" // 屏蔽人
    case hp_watch_person = "\u{eacf}" // 查看人
    
    case hp_shield_content = "\u{ead2}" // 屏蔽内容
    case hp_watch_content = "\u{ead1}" // 查看内容
    
    case hp_addVideo = "\u{e751}"
    case hp_video = "\u{ea89}" // video
    //    case hp_empty_video = "\u{eac6}"
    case qr_code_timeline = "\u{e9ea}"
    case qr_code_zone = "\u{ea18}"
    case qr_code_other = "\u{e802}"
    
    case hp_chat = "\u{e7d9}"
    
    // 好友 tab
    case f_scan = "\u{eac5}"
    case f_weixin = "\u{e7de}"
    case f_qq = "\u{eabd}"
    case f_contact = "\u{e71d}"
    case f_more_menu = "\u{ea7a}"
    case f_save_image = "\u{e8df}"
    case f_share = "\u{e9de}"
    
    // 扫描 添加好友界面
    //    case open_photo = hp_qrCode
    case command_word = "\u{e8f9}"
    
    case hp_upload_close = "\u{e963}"
    case hp_upload_retry = "\u{e9b5}"
    
}
