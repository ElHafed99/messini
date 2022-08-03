<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Access-Control-Allow-Origin, Accept");
header("Content-Type: application/json; charset=UTF-8");

require_once 'db.php';

$recived_data = json_decode(file_get_contents('php://input'), true);


if(isset($recived_data['action']) && $recived_data['action'] == "firstRun"){
	$sql = file_get_contents('shopapp.sql');
	
	$result = $conn->multi_query($sql);
	if ($result) {
		echo json_encode(array("type" => "success"),JSON_UNESCAPED_UNICODE);
	} else {
		echo json_encode(array("type" => "faild"),JSON_UNESCAPED_UNICODE);
	}
	$conn->close();
}




if(isset($recived_data['action']) && $recived_data['action'] == "checkUserExist")
{


	$userUid = $recived_data['userUid'];
	$userPhone = $recived_data['userPhone'];

	$sql = "SELECT * FROM users WHERE uid = '$userUid'";
	$result = $conn->query($sql);


	if ($result->num_rows > 0) {
		echo json_encode(array("message" => "User Exist"),JSON_UNESCAPED_UNICODE);
	} else {
		$conn->query("INSERT INTO users (phone, uid) VALUES ('$userPhone', '$userUid')");
		echo json_encode(array("message" => "User added"),JSON_UNESCAPED_UNICODE);
	}
	$conn->close();
}


if(isset($recived_data['action']) && $recived_data['action'] == "getLatestProducts")
{
	$sql = "SELECT * FROM products WHERE showToUser = 1 LIMIT 10";
	$result = $conn->query($sql);

	$productArray = array();
	$productArray["data"] = array();

	if ($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
			array_push($productArray["data"], $row);
		}
		echo json_encode($productArray,JSON_UNESCAPED_UNICODE);
	} else {
		echo json_encode($productArray,JSON_UNESCAPED_UNICODE);
	}
	$conn->close();
}

if(isset($recived_data['action']) && $recived_data['action'] == "getAllProducts")
{
	$sql = "SELECT * FROM products";
	$result = $conn->query($sql);

	$productArray = array();
	$productArray["data"] = array();

	if ($result->num_rows > 0) {
  
		while($row = $result->fetch_assoc()) {
			array_push($productArray["data"], $row);
		}
		echo json_encode($productArray,JSON_UNESCAPED_UNICODE);
	} else {
		echo json_encode($productArray,JSON_UNESCAPED_UNICODE);
	}
	$conn->close();
}



if(isset($recived_data['action']) && $recived_data['action'] == "getCategories")
{
	$sql = "SELECT * FROM categories WHERE showToUser = 1";
	$result = $conn->query($sql);

	$categoryArray = array();
	$categoryArray["data"] = array();

	if ($result->num_rows > 0) {
  
		while($row = $result->fetch_assoc()) {
			array_push($categoryArray["data"], $row);
		}
		echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
	} else {
		echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
	}
	$conn->close();}

	if(isset($recived_data['action']) && $recived_data['action'] == "getAllCategories")
{
	$sql = "SELECT * FROM categories";
	$result = $conn->query($sql);

	$categoryArray = array();
	$categoryArray["data"] = array();

	if ($result->num_rows > 0) {
  
		while($row = $result->fetch_assoc()) {
			array_push($categoryArray["data"], $row);
		}
		echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
	} else {
		echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
	}
	$conn->close();}



	if(isset($recived_data['action']) && $recived_data['action'] == "getSliders")
	{
		$sql = "SELECT * FROM sliders WHERE showToUser = 1";
		$result = $conn->query($sql);

		$sliderArray = array();
		$sliderArray["data"] = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				array_push($sliderArray["data"], $row);
			}
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();
	}

	if(isset($recived_data['action']) && $recived_data['action'] == "getAllSliders")
	{
		$sql = "SELECT * FROM sliders";
		$result = $conn->query($sql);

		$sliderArray = array();
		$sliderArray["data"] = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				array_push($sliderArray["data"], $row);
			}
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();
	}



	if(isset($recived_data['action']) && $recived_data['action'] == "getProductByCategory")
	{
		$categoryId = $recived_data['categoryId'];
		$sql = "SELECT * FROM products WHERE categoryId = '$categoryId' AND showToUser = 1";
		$result = $conn->query($sql);

		$sliderArray = array();
		$sliderArray["data"] = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				array_push($sliderArray["data"], $row);
			}
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();
	}

	if(isset($recived_data['action']) && $recived_data['action'] == "getDriverByPhone")
	{
		$driverPhone = $recived_data['driverPhone'];
		$sql = "SELECT * FROM drivers WHERE phone = '$driverPhone'";
		$result = $conn->query($sql);

		$sliderArray = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				$sliderArray["data"] = $row;
			}
			echo json_encode(
					array("message" => "", "type" =>"success", "data" => $sliderArray["data"]),JSON_UNESCAPED_UNICODE
				);
			
		} else {
			$sliderArray["data"] = array();
			echo json_encode(
					array("message" => "No data", "type" =>"faild")
				);
		}
		$conn->close();
	}

	if(isset($recived_data['action']) && $recived_data['action'] == "getUserOrders")
	{
		$userUid = $recived_data['userUid'];
		$sql = "SELECT * FROM orders WHERE userUid = '$userUid' ORDER BY createdAt DESC";
		$result = $conn->query($sql);

		$sliderArray = array();
		$sliderArray["data"] = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				array_push($sliderArray["data"], $row);
			}
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();
	}

	if(isset($recived_data['action']) && $recived_data['action'] == "getDriverOrders")
	{
		$driverId = $recived_data['driverId'];
		$sql = "SELECT * FROM orders WHERE driverId = '$driverId' ORDER BY createdAt DESC";
		$result = $conn->query($sql);

		$sliderArray = array();
		$sliderArray["data"] = array();

		if ($result->num_rows > 0) {
  		
			while($row = $result->fetch_assoc()) {
				array_push($sliderArray["data"], $row);
			}
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();
	}

	if(isset($recived_data['action']) && $recived_data['action'] == "getUsers")
	{
		$sql = "SELECT * FROM users";
		$result = $conn->query($sql);

		$categoryArray = array();
		$categoryArray["data"] = array();

		if ($result->num_rows > 0) {
  
			while($row = $result->fetch_assoc()) {
				array_push($categoryArray["data"], $row);
			}
			echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
		} else {
			echo json_encode($categoryArray,JSON_UNESCAPED_UNICODE);
		}
		$conn->close();}

		if(isset($recived_data['action']) && $recived_data['action'] == "addOrder")
		{
			$orderItems = $recived_data['orderItems'];
			$userLocation = $recived_data['userLocation'];
			$userPhone = $recived_data['userPhone'];
			$userUid = $recived_data['userUid'];
			$userLatLng = $recived_data['userLatLng'];
			$passcode = $recived_data['passcode'];

			$sql = "INSERT INTO orders (orderItems, userLocation, userPhone, userUid,statusId,userLatLng,passcode) VALUES ('$orderItems', '$userLocation', '$userPhone', '$userUid', '0', '$userLatLng', '$passcode')";
			$result = $conn->query($sql); 

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Order created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Order not created", "type" =>"faild", "error" => $conn->error)
				);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "cancelOrder")
		{
			$orderId = $recived_data['orderId'];



			$sql = "UPDATE orders SET statusId = -1 WHERE id='$orderId'";
			$result = $conn->query($sql);

			if ($result === TRUE) {
 				echo json_encode(
					array("message" => "Order cancel successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Order not cancel", "type" =>"faild")
				);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "confirmOrder")
		{
			$orderId = $recived_data['orderId'];
			$driverId = $recived_data['driverId'];


			$sql = "UPDATE orders SET statusId = 2 WHERE id='$orderId'";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Order confirmed successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Order not confirmed", "type" =>"faild", "error" =>$conn->error)
				);
			}


			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "addProduct")
		{
			$title = $recived_data['title'];
			$image = $recived_data['image'];
			$description = $recived_data['description'];
			$price = $recived_data['price'];
			$unit = $recived_data['unit'];
			$unitSize = $recived_data['unitSize'];
			$categoryId = $recived_data['categoryId'];
			$showToUser = $recived_data['showToUser'];

			$sql = "INSERT INTO products (title, image, description, price, unit, unitSize, categoryId, showToUser) VALUES ('$title', '$image', '$description', '$price', '$unit' ,'$unitSize', '$categoryId', '$showToUser')";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Product created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Product not created", "type" =>"faild")
				);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "addCategory")
		{
			$title = $recived_data['title'];
			$image = $recived_data['image'];
			$showToUser = $recived_data['showToUser'];

			$sql = "INSERT INTO categories (title, image, showToUser) VALUES ('$title', '$image', '$showToUser')";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Category created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Category not created", "type" =>"faild")
				);
			}

 			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "addSlider")
		{
			$title = $recived_data['title'];
			$subtitle = $recived_data['subtitle'];
			$image = $recived_data['image'];
			$color = $recived_data['color'];
			$showToUser = $recived_data['showToUser'];

			$sql = "INSERT INTO sliders (title, subtitle, image, color, showToUser) VALUES ('$title', '$subtitle', '$image', '$color', '$showToUser')";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Category created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Category not created", "type" =>"faild")
				);
			}

 			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "addDriver")
		{
			$name = $recived_data['name'];
			$phone = $recived_data['phone'];
			$available = $recived_data['available'];

			$sql = "INSERT INTO drivers (name, phone, available) VALUES ('$name', '$phone', '$available')";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Category created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Category not created", "type" =>"faild")
				);
			}

 			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "deleteProduct")
		{
			$productId = $recived_data['productId'];

			$sql = "DELETE FROM products WHERE id='$productId'";
			$result = $conn->query($sql);
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Product deleted successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Product not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "deleteCategory")
		{
			$categoryId = $recived_data['categoryId'];

			mysqli_query($conn, "START TRANSACTION");

			$query1 = mysqli_query($conn,"DELETE FROM categories WHERE id='$categoryId'");
			$query2 = mysqli_query($conn,"DELETE FROM products WHERE categoryId='$categoryId'");


			if ($query1 and $query2) {
				mysqli_query($conn,"COMMIT");
				echo json_encode(
					array("message" => "Category deleted successfully", "type" =>"success")
				);
			} else {
				mysqli_query($conn,"ROLLBACK");
				echo json_encode(
					array("message" => "Category not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "deleteSlider")
		{
			$sliderId = $recived_data['sliderId'];

			$sql = "DELETE FROM sliders WHERE id='$sliderId'";
			$result = $conn->query($sql);
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Slider deleted successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Slider not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "deleteDriver")
		{
			$driverId = $recived_data['driverId'];

			$sql = "DELETE FROM drivers WHERE id='$driverId'";
			$result = $conn->query($sql);
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Driver deleted successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Driver not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "deleteOrder")
		{
			$orderId = $recived_data['orderId'];

			$sql = "DELETE FROM orders WHERE id='$orderId'";
			$result = $conn->query($sql);
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Order deleted successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Order not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}

		


		if(isset($recived_data['action']) && $recived_data['action'] == "getCategoryById")
		{
			$categoryId = $recived_data['categoryId'];
			$sql = "SELECT * FROM categories WHERE id = '$categoryId'";
			$result = $conn->query($sql);

			$sliderArray = array();
 
			if ($result->num_rows > 0) {
  		
				while($row = $result->fetch_assoc()) {
 					$sliderArray["data"] = $row;
				}
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			} else {
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			}
			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "editProduct")
		{
			$id = $recived_data['id'];
			$title = $recived_data['title'];
			$image = $recived_data['image'];
			$description = $recived_data['description'];
			$price = $recived_data['price'];
			$unit = $recived_data['unit'];
			$unitSize = $recived_data['unitSize'];
			$categoryId = $recived_data['categoryId'];
			$showToUser = $recived_data['showToUser'];

			$sql = "UPDATE  products SET title = '$title', image = '$image', description = '$description', price = '$price', unit = '$unit', unitSize = '$unitSize', categoryId = '$categoryId', showToUser = '$showToUser' WHERE id = '$id'";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Product updated successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Product not updated", "type" =>"faild")
				);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "editCategory")
		{
			$id = $recived_data['id'];
			$title = $recived_data['title'];
			$image = $recived_data['image'];
			$showToUser = $recived_data['showToUser'];

			$sql = "UPDATE  categories SET title = '$title', image = '$image', showToUser = '$showToUser' WHERE id = '$id'";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Category updated successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Category not updated", "type" =>"faild")
				);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "editSlider")
		{
			$id = $recived_data['id'];
			$title = $recived_data['title'];
			$subtitle = $recived_data['subtitle'];
			$image = $recived_data['image'];
			$color = $recived_data['color'];
			$showToUser = $recived_data['showToUser'];

			$sql = "UPDATE sliders SET title = '$title', subtitle = '$subtitle', image = '$image', color = '$color', showToUser = '$showToUser' WHERE id = '$id'";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Slider updated successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Slider not updated", "type" =>"faild")
				);
			}
			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "getOrders")
		{

			$sql = "SELECT * FROM orders";
			$result = $conn->query($sql);

			$sliderArray = array();
			$sliderArray["data"] = array();

			if ($result->num_rows > 0) {
  		
				while($row = $result->fetch_assoc()) {
					array_push($sliderArray["data"], $row);
				}
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			} else {
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			}
			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "getDrivers")
		{

			$sql = "SELECT * FROM drivers";
			$result = $conn->query($sql);

			$sliderArray = array();
			$sliderArray["data"] = array();

			if ($result->num_rows > 0) {
  		
				while($row = $result->fetch_assoc()) {
					array_push($sliderArray["data"], $row);
				}
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			} else {
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "getNotifications")
		{

			$sql = "SELECT * FROM notifications";
			$result = $conn->query($sql);

			$sliderArray = array();
			$sliderArray["data"] = array();

			if ($result->num_rows > 0) {
  		
				while($row = $result->fetch_assoc()) {
					array_push($sliderArray["data"], $row);
				}
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			} else {
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			}
			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "addNotification")
		{
			$title = $recived_data['title'];
			$description = $recived_data['description'];
			$toUser = $recived_data['toUser'];

			$sql = "INSERT INTO notifications (title, description, toUser) VALUES ('$title', '$description', '$toUser')";
			$result = $conn->query($sql);

			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Notification created successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Notification not created", "type" =>"faild", "error" => $conn->error)
				);
			}

 			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "deleteNotification")
		{
			$notificationId = $recived_data['notificationId'];

			$sql = "DELETE FROM notifications WHERE id='$notificationId'";
			$result = $conn->query($sql);
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Notification deleted successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Notification not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}




		if(isset($recived_data['action']) && $recived_data['action'] == "attachDriverToOrder")
		{
			$orderId = $recived_data['orderId'];
			$driverId = $recived_data['driverId'];


			$sql ="UPDATE orders SET statusId = 1, driverId = '$driverId' WHERE id='$orderId'";
			$result = $conn->query($sql);
			
			if ($result === TRUE) {
				echo json_encode(
					array("message" => "Order updated successfully", "type" =>"success")
				);
			} else {
				echo json_encode(
					array("message" => "Order not updated", "type" =>"faild", "error" =>$conn->error)
				);
			}


			$conn->close();
		}

		if(isset($recived_data['action']) && $recived_data['action'] == "deleteUser")
		{
			$userUid = $recived_data['userUid'];

			mysqli_query($conn, "START TRANSACTION");

			$sql1 = mysqli_query($conn,"DELETE FROM users WHERE uid='$userUid'");
			$sql2 = mysqli_query($conn,"DELETE FROM orders WHERE userUid = '$userUid'");
			
			if ($sql1 and $sql2) {
				mysqli_query($conn,"COMMIT");
				echo json_encode(
					array("message" => "User deleted successfully", "type" =>"success")
				);
			} else {
				mysqli_query($conn,"ROLLBACK");
				echo json_encode(
					array("message" => "User not deleted", "type" =>"faild")
				);
			}


			$conn->close();
		}


		if(isset($recived_data['action']) && $recived_data['action'] == "getDriverById")
		{
			$driverId = $recived_data['driverId'];
			$sql = "SELECT * FROM drivers WHERE id = '$driverId'";
			$result = $conn->query($sql);

			$sliderArray = array();

			if ($result->num_rows > 0) {
				while($row = $result->fetch_assoc()) {
					$sliderArray["data"] = $row;
				}
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			} else {
				echo json_encode($sliderArray,JSON_UNESCAPED_UNICODE);
			}
			$conn->close();
		}




	?>