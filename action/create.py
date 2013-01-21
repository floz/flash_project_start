#!/usr/bin/env python -B
# -*- coding: utf-8 -*-

import shutil
import errno
import os
import cmd
import sys

class Create( object ):

	folders = [ '/__build', '/bin', '/lib', '/src' ]

	def __init__( self, script_dir_path ):
		Create.script_dir_path = script_dir_path

	def create( self ):
		some_folder_exist = False		
		for folder in Create.folders:
			if os.path.exists( "." + folder ):
				some_folder_exist = True
				break;
		
		if some_folder_exist:
			print "WARNING !!"
			print "Des dossiers nécessaires à la création du projet existent déjà."
			print "Si vous validez votre choix, ils seront supprimés et recrées."
			print "Tappez 'y' pour valider, 'n' pour annuler."
			CreateCommand().cmdloop()
		else:
			Create.create_project()

	@staticmethod
	def create_project():
		stri = Create.script_dir_path + "/mmp_project/base"
		for folder in Create.folders:
			src = stri + folder
			dst = "." + folder
			if os.path.exists( dst ):
				shutil.rmtree( dst )
			shutil.copytree( src, dst )
		print "Le projet a bien été crée !"

class CreateCommand( cmd.Cmd ):

	def do_y( self, line ):
		Create.create_project()		
		return True

	def do_n( self, line ):
		print "Action annulée."
		return True