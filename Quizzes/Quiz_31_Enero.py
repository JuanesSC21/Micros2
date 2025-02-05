import numpy as np

def calculate_robot_positions(v_right, v_left, d, dt, total_time):
    """
    Calcula las posiciones del robot dado las velocidades de las ruedas.
    
    Parámetros:
    v_right: lista de velocidades de la rueda derecha
    v_left: lista de velocidades de la rueda izquierda
    d: distancia desde el centro a cada rueda
    dt: intervalo de tiempo entre mediciones
    total_time: tiempo total de simulación
    
    Retorna:
    positions_x: lista de posiciones x
    positions_y: lista de posiciones y
    angles: lista de ángulos
    """
    # Inicializar listas para almacenar resultados
    positions_x = [0]  # Posición inicial x = 0
    positions_y = [0]  # Posición inicial y = 0
    angles = [0]      # Ángulo inicial = 0
    
    # Número de pasos de tiempo
    steps = int(total_time / dt)
    
    # Para cada paso de tiempo
    for i in range(steps):
        # Obtener velocidades actuales
        vr = v_right[i] if i < len(v_right) else v_right[-1]
        vl = v_left[i] if i < len(v_left) else v_left[-1]
        
        # Calcular velocidad del centro (Vc)
        v_c = (vr + vl) / 2
        
        # Calcular el cambio de ángulo
        omega = (vr - vl) / (2 * d)  # Velocidad angular
        
        # Obtener el ángulo actual
        current_angle = angles[-1]
        
        # Calcular el nuevo ángulo
        new_angle = current_angle + omega * dt
        
        # Calcular las nuevas posiciones
        dx = v_c * np.cos(current_angle) * dt
        dy = v_c * np.sin(current_angle) * dt
        
        # Actualizar posiciones
        new_x = positions_x[-1] + dx
        new_y = positions_y[-1] + dy
        
        # Guardar nuevos valores
        positions_x.append(new_x)
        positions_y.append(new_y)
        angles.append(new_angle)
    
    return positions_x, positions_y, angles
