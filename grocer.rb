require 'pry'

def consolidate_cart(cart)
  inventory = {}
  cart.each do |item_hash|
    item_hash.each do |item, info|
      if inventory.key?(item)
        inventory[item][:count] += 1
      else
        inventory[item] = info
        inventory[item][:count] = 1
      end
    end
  end
  return inventory
end

def apply_coupon(cart, discounted_item, coupon)
  cart[discounted_item][:count] = cart[discounted_item][:count] - coupon[:num]
  if cart.key?("#{discounted_item} W/COUPON")
    cart["#{discounted_item} W/COUPON"][:count] += 1
  else
    cart["#{discounted_item} W/COUPON"] = {
      :price => coupon[:cost],
      :clearance => cart[discounted_item][:clearance],
      :count => 1
    }
  end
  return cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    discounted_item = coupon[:item]
    next if !cart.key?(discounted_item)
    if cart[discounted_item][:count] >= coupon[:num]
      cart = apply_coupon(cart, discounted_item, coupon)
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |info, info_values|
    if info_values[:clearance]
      info_values[:price] = (info_values[:price] * 0.8).round(2)
    end
  end
  return cart
end

def cart_total(cart)
  total_price = 0
  cart.each do |item, item_info|
    total_price += item_info[:count] * item_info[:price]
  end
  return total_price
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_price = cart_total(cart)
  return total_price > 100 ? total_price * 0.9 : total_price
end
