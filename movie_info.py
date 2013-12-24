#! /usr/bin/python
# -*- coding: utf-8 -*-

# Copyright (C) 2011 ~ 2012 Deepin, Inc.
#               2011 ~ 2012 Wang Yong
# 
# Author:     Wang Yong <lazycat.manatee@gmail.com>
# Maintainer: Wang Yong <lazycat.manatee@gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from PyQt5.QtCore import pyqtSlot, QObject
from constant import DEFAULT_WIDTH, DEFAULT_HEIGHT
from media_info import parse_info

class MovieInfo(QObject):

    def __init__(self, filepath=""):
        QObject.__init__(self)
        
        self.filepath = filepath
        self.media_info = None
        self.media_width = DEFAULT_WIDTH
        self.media_height = DEFAULT_HEIGHT
        
        if self.filepath != "":
            self.media_info = parse_info(self.filepath)
            self.media_width = self.media_info["video_width"]
            self.media_height = self.media_info["video_height"]

    @pyqtSlot(result=int)        
    def get_movie_width(self):
        return int(self.media_width)
        
    @pyqtSlot(result=int)    
    def get_movie_height(self):
        return int(self.media_height)

    @pyqtSlot(result=str)    
    def get_movie_file(self):
        return self.filepath
