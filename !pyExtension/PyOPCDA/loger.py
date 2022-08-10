# -*- coding: utf-8 -*-
from traceback import format_exc

class TLoger():
    def __init__(self, Name):
        self.__name = Name

    def tolog(self, text='', pref=''):
        print('{}\t{} - {}'.format( pref, self.__name, text))

    def Errlog(self, text='', pref=''):
        s1 = '═'*80
        s2 = '─'*80
        self.tolog( '{txt}\n{sep2}\n{err}{sep1}'.format(sep1=s1, sep2=s2, txt=text, err=format_exc()) , '\n{sep1}\n'.format(sep1=s1) )
