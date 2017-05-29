
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet var table: UITableView!
   

    var list:[MyStruct] = [MyStruct]()
    
    struct MyStruct
    {
        var categorias = ""
        var domicilio  = ""
        var url_detalle = ""
        var logo_path = ""
        var nombre = ""
        var rating = ""
        var tiempo_domicilio = ""
        var ubicacion_txt = ""

        
        init(_ nombre:String,
             _ domicilio:String,
             _ url_detalle:String,
             _ categorias:String,
             _ logo_path:String,
             _ rating:String,
             _ tiempo_domicilio:String,
             _ ubicacion_txt:String)
        {
            self.nombre = nombre
            self.categorias = categorias
            self.domicilio = domicilio
            self.url_detalle = url_detalle
            self.logo_path = logo_path
            self.nombre = nombre
            self.rating = rating
            self.tiempo_domicilio = tiempo_domicilio
            self.ubicacion_txt = ubicacion_txt

        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        get_data("https://api.myjson.com/bins/1zib8")
    }
    
    
    func get_data(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            self.extract_data(data)
            
        })
        
        task.resume()
    }
    
    
    func extract_data(_ data:Data?)
    {
        let json:Any?
        
        if(data == nil)
        {
            return
        }
        
        do{
            json = try JSONSerialization.jsonObject(with: data!, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_array = json as? NSArray else
        {
            return
        }
        
        
        for i in 0 ..< data_array.count
        {
            if let data_object = data_array[i] as? NSDictionary
            {
                    if  let nombre = data_object["nombre"] as? String,
                        let categorias = data_object["categorias"] as? String,
                        let domicilio = data_object["domicilio"] as? String,
                        let url_detalle = data_object["url_detalle"] as? String,
                        let logo_path = data_object["logo_path"] as? String,
                        let ubicacion_txt = data_object["ubicacion_txt"] as? String,
                        let rating = data_object["rating"] as? String,
                        let tiempo_domicilio = data_object["tiempo_domicilio"] as? String
                        
                    {
                        list.append(MyStruct(nombre,
                                             domicilio,
                                             url_detalle,
                                             categorias,
                                             logo_path,
                                             rating,
                                             tiempo_domicilio,
                                             ubicacion_txt))
                    }
                
            }
        }


        refresh_now()
        
        
    }

    func refresh_now()
    {
        DispatchQueue.main.async(
        execute:
        {
            self.table.reloadData()
            
        })
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let imagePath = list[indexPath.row].logo_path
        let imageUrl = NSURL(string: imagePath)
        if let imageData = NSData(contentsOf: imageUrl! as URL){
            cell.imageViewControl.image = UIImage(data: imageData as Data)
        }
        
        cell.labelView.text = "Precio: " + list[indexPath.row].domicilio
        cell.labelTimepo.text =  "Tiempo Espera: " + list[indexPath.row].tiempo_domicilio
        cell.labelNombre.text = "Nombre: " +  list[indexPath.row].nombre
        
        
        return cell
    }
    
}

