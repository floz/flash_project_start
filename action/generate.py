#!/usr/bin/env python -B
# -*- coding: utf-8 -*-

from xml.dom.minidom import parse
import shutil
import os

class Generate( object ):

	package_string = ""
	package_path = ""
	url_base_module = ""
	url_base_modulewithoutnav = ""
	url_base_navids = ""
	url_base_navmanager = ""

	modules = []

	def __init__( self, script_dir_path ):
		base = script_dir_path + "/mmp_project/ref"
		self.url_base_module = base + "/module/BaseModule.as"
		self.url_base_modulewithoutnav = base + "/module/BaseModuleWithoutNav.as"
		self.url_base_navids = base + "/nav/NavIds.as"
		self.url_base_navmanager = base + "/nav/navManager.as"

	def generate( self ):
		try:
			data_source = open( "./__build/project.xml" )
			dom = parse( data_source )
			self.__handlePackage( dom.getElementsByTagName( "package" )[ 0 ] )
			self.__handleModules( dom.getElementsByTagName( "modules" )[ 0 ] )

			if self.modules == None:
				print "!! Le noeud 'modules' du xml '__build/project.xml' n'a pas été édité !!"
				print "!! Le projet n'a pas été généré. !!"
				return

			self.__generate( self.modules, "./src/" + self.package_path, self.package_string, True )

			print "Génération du projet effectuée."
			print "gl, hf gosu !"
		except IOError:
			print "ERROR !!"
			print "Il ne semble pas y avoir de projet généré dans ce dossier..."
			print "Avez vous éxécuté la commande 'mmp create' ?"

	def __handlePackage( self, mode_package ):
		prefix = mode_package.getElementsByTagName( "prefix" )[ 0 ].childNodes[ 0 ].data
		client = mode_package.getElementsByTagName( "client" )[ 0 ].childNodes[ 0 ].data
		project = mode_package.getElementsByTagName( "project" )[ 0 ].childNodes[ 0 ].data

		self.package_string = prefix + "." + client + "." + project
		self.package_path = self.package_string.replace( ".", "/" )

	def __handleModules( self, node_modules ):
		self.modules = self.__grabModules( node_modules )

	def __grabModules( self, main_node ):
		data = {}
		for node in main_node.childNodes:
			if node.nodeType == node.ELEMENT_NODE:
				data[ node.getAttribute( "id" ) ] = self.__grabModules( node )

		if len( data ) > 0:
			return data
		return None

	def __generate( self, node, base_folder, package_string, is_root = False ):
		for id in node:
			id_uppercase = id[:1].upper() + id[1:]
			if is_root == False:
				filename = id_uppercase + "Module.as"
			else:
				filename = "Main" + id_uppercase + ".as"
			folder = base_folder + "/" + id

			src_module = self.url_base_modulewithoutnav;
			elements_module_to_replace = []
			if node[ id ] != None:
				src_module = self.url_base_module
				package_module_string = package_string + "." + id

				self.__generate( node[ id ], folder + "/module", package_module_string + ".module" )

				filename_navids = "Nav" + id_uppercase + "Ids.as"
				filename_navmanager = "nav" + id_uppercase + ".as"
				self.__copyFile( self.url_base_navids, folder + "/nav/", filename_navids )
				self.__copyFile( self.url_base_navmanager, folder + "/nav/", filename_navmanager )

				elements_nav_to_replace = []
				elements_nav_to_replace.append( { "name": "{package}", "value": package_module_string + ".nav" } )
				elements_nav_to_replace.append( { "name": "{classname}", "value": "nav" + id_uppercase } )
				self.__replace( folder + "/nav/" + filename_navmanager, elements_nav_to_replace )

				r_importmodules = ""
				r_modules = ""
				r_navids = ""
				idx = 0
				for nav_id in node[ id ]:
					module_id_uppercase = nav_id[:1].upper() + nav_id[ 1: ]
					if not idx == 0:
						r_importmodules = r_importmodules + "\n\t"
						r_modules = r_modules + ", "
						r_navids = r_navids + "\n\t\t"
					r_importmodules = r_importmodules + "import " + package_module_string + ".module." + nav_id + ".module." + module_id_uppercase + "Module"
					r_modules = r_modules + "new ModuleInfo( Nav" + id_uppercase + "Ids." + nav_id.upper() + ", " + module_id_uppercase + "Module )"
					r_navids = r_navids + "public static const " + nav_id.upper() + ":String = \"" + nav_id + "\";"
					idx += 1

				elements_nav_to_replace = []
				elements_nav_to_replace.append( { "name": "{content}", "value": r_navids } )
				elements_nav_to_replace.append( { "name": "{package}", "value": package_module_string + ".nav" } )
				elements_nav_to_replace.append( { "name": "{classname}", "value": "Nav" + id_uppercase + "Ids" } )
				self.__replace( folder + "/nav/" + filename_navids, elements_nav_to_replace )

				elements_module_to_replace.append( { "name": "{importmodules}", "value": r_importmodules } )
				elements_module_to_replace.append( { "name": "{modules}", "value": r_modules } )

			elements_module_to_replace.append( { "name": "{package}", "value": package_string + "." + id } )
			elements_module_to_replace.append( { "name": "{modulename}", "value": id_uppercase } )

			self.__copyFile( src_module, folder, filename )
			self.__replace( folder + "/" + filename, elements_module_to_replace )

	def __copyFile( self, src, path_folder, filename ):
		if not os.path.exists( path_folder ):
			os.makedirs( path_folder )
		shutil.copy( src, path_folder + "/" + filename )

	def __replace( self, path_file, data ):
		f = file( path_file )
		stri = f.read()
		f.close()
		for entry in data:
			stri = stri.replace( entry[ "name" ], entry[ "value" ] )
		f = file( path_file, "w" )
		f.write( stri )
		f.close()