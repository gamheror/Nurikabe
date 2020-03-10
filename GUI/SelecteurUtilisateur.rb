require 'gtk3'

module Gui
    
    ##
    # Fenêtre permettant de choisir un utilisateur ou d'en créer un.
    class SelecteurUtilisateur < Gtk::Dialog
        
        ##
        # Ligne du sélecteur d'utilisateur représentant un utilisateur.
        class Ligne < Gtk::Box
            
            ##
            # Label où sont écrites les informations (Gtk::Label)
            attr_reader :label
            
            ##
            # Utilisateur concerné
            attr_accessor :utilisateur
            
            private_class_method :new
            
            ##
            # Crée une ligne pour l'utilisateur donné.
            #
            # Paramètres :
            # [+utilisateur+]   Utilisateur
            def Ligne.creer(utilisateur)
                ligne = new
                ligne.label.markup = "<b>#{utilisateur.nom}</b>\n" + 
                        "<span weight=\"light\" style=\"italic\"> Crédit : " +
                        "#{utilisateur.credit}</span>"
                ligne.utilisateur = utilisateur
                return ligne
            end
            
            ##
            # Crée une ligne qui accueillera les données de l'utilisateur.
            #
            # Méthode privée, utiliser Gui::SelecteurUtilisateur::Ligne.creer.
            def initialize
                super(:horizontal)
                icone = Gtk::Image.new(icon_name: 'user', size: :dialog)
                icone.pixel_size = 48
                icone.margin_left = 4
                icone.margin_right = 4
                icone.margin_top = 4
                icone.margin_bottom = 4
                icone.show
                self.pack_start(icone)
                @label = Gtk::Label.new
                @label.margin_top = 4
                @label.margin_bottom = 4
                @label.margin_right = 4
                @label.show
                self.pack_start(@label)
                self.show
            end
            
        end
        
        ##
        # Boîte de dialogue permettant de créer un nouvel utilisateur.
        class NouvelUtilisateurDialogue < Gtk::Dialog
        
            ##
            # Identifiant de l'action _Annuler_ (Integer)
            ANNULER = 0
            
            ##
            # Identifiant de l'action _Créer un utilisateur_ (Integer)
            CREER = 1
            
            ##
            # Crée une nouvelle boîte de dialogue permettant de créer un
            # utilisateur.
            #
            # Paramètres :
            # [+parent+]    Fenêtre parente à la boîte de dialogue
            def initialize(parent)
                super(parent: parent)
                box_principale = Gtk::Box.new(:horizontal)
                box_principale.expand = true
                icone = Gtk::Image.new(icon_name: 'user', size: :dialog)
                icone.pixel_size = 64
                icone.margin_left = 4
                icone.margin_right = 4
                icone.margin_top = 4
                icone.margin_bottom = 4
                icone.show
                box_principale.pack_start(icone)
                box_secondaire = Gtk::Box.new(:vertical)
                box_secondaire.expand = true
                label = Gtk::Label.new("Nom d'utilisateur :")
                label.xalign = 0
                label.show
                box_secondaire.pack_start(label)
                champs = Gtk::Entry.new
                champs.show
                box_secondaire.pack_start(champs)
                box_secondaire.show
                box_principale.add(box_secondaire)
                box_principale.show
                self.content_area.add(box_principale)
                self.add_button("Annuler", ANNULER)
                self.add_button("Créer un utilisateur", CREER)
                self.signal_connect("response") { |dialogue, action|
                    case action
                    when ANNULER then
                        dialogue.close
                    end
                }
                self.show
            end
            
        end
        
        ##
        # Gtk::ListBox contenant les Gtk::SelecteurUtilisateur::Ligne
        attr_reader :liste
        
        private_class_method :new
        
        ##
        # Crée un sélecteur d'utilisateurs.
        #
        # Paramètres :
        # [+parent+]        Fenêtre parente au sélecteur d'utilisateur
        # [+utilisateurs+]  Utilisateurs à ajouter (Array de Utilisateur)
        def SelecteurUtilisateur.creer(parent, utilisateurs)
            selecteur = new(parent)
            utilisateurs.each { |u| selecteur.liste.insert(Ligne.creer(u), -1) }
            return selecteur
        end
        
        ##
        # Crée la fenêtre du sélecteur d'utilisateur.
        #
        # Méthode privée, utiliser Gui::SelecteurUtilisateur.creer.
        #
        # Paramètres :
        # [+parent+]    Fenêtre parente au sélecteur d'utilisateur
        def initialize(parent)
            super(parent: parent)
            self.title = "Sélectionnez un utilisateur"
            self.default_width = 600
            self.default_height = 400
            box = Gtk::Box.new(:vertical)
            scrolled_window = Gtk::ScrolledWindow.new
            @liste = Gtk::ListBox.new
            @liste.selection_mode = :single
            @liste.signal_connect("row-activated") { |liste, ligne|
                puts "Utilisateur #{ligne.children[0].utilisateur} sélectionné"
                self.close
            }
            @liste.show
            scrolled_window.add_with_viewport(@liste)
            scrolled_window.expand = true
            scrolled_window.show
            box.pack_start(scrolled_window, {fill: true})
            nouvel_utilisateur = Gtk::Button.new(label: "Nouvel utilisateur")
            nouvel_utilisateur.signal_connect("clicked") { |bouton|
                NouvelUtilisateurDialogue.new(self)
            }
            nouvel_utilisateur.show
            box.pack_end(nouvel_utilisateur)
            box.expand = true
            box.show
            self.content_area.add(box)
            self.signal_connect("destroy") { Gtk.main_quit }
            self.show
        end
        
    end
    
end
        
